@RestResource(urlMapping='/submitquote/*')
global class BaldwinAsyncQuoteWebservice {
    global static string requestBody;

    @HttpPost
    global static void handleQuote() {
        RestRequest request = RestContext.request;
        RestResponse response = new RestResponse();
        response.statusCode = 200;
        response.responseBody = Blob.valueOf('Success');
        requestBody = request.requestBody.toString();
        System.debug('--- RestRequest: ' + requestBody);
        // System.debug('--- body: ' + body);
        BaldwinQuoteResponseObj dataWrap = BaldwinQuoteResponseObj.parse(requestBody.replace('_',''));

        if(dataWrap != null)
            response = doInsert(dataWrap, response, 0);

        RestContext.response = response;
    }

    public static void retryDoInsert(String json, Integer attempt) {
        requestBody = json;
        doInsert(BaldwinQuoteResponseObj.parse(requestBody.replace('_','')), new RestResponse(), attempt);
    }

    private static RestResponse doInsert(BaldwinQuoteResponseObj dataWrap, RestResponse response, Integer attempt) {
        System.debug('--- datawrap: ' + dataWrap);

        if(String.isNotBlank(dataWrap.status) && (dataWrap.status.containsIgnoreCase('error') || dataWrap.status.containsIgnoreCase('failed') )){
            publishAyncToastEvent(dataWrap.opportunityId, dataWrap.carrier, dataWrap.message, 'error', 'dismissible');

            Quoting_Error__c e = new Quoting_Error__c();
            e.Carrier__c = dataWrap.carrier;
            e.Line_of_Business__c = dataWrap.lob;
            e.Completion__c = dataWrap.completion;
            e.Error_Message__c = dataWrap.message.length() > 255 ? dataWrap.message.substring(0, 255) : dataWrap.message;
            e.Opportunity__c = dataWrap.opportunityId;
            e.Status__c = dataWrap.status;
            e.Error_ID__c = (dataWrap.executionId != null ? String.valueOf(dataWrap.executionId) : null);
            insert e;

        }
        else {
            List<Quote> quoteList = new List<Quote>();
            if(!dataWrap.quotes.isEmpty()){
                
                Quote baseQuote = new Quote();
                baseQuote.Name = dataWrap.carrier + ' ' + dataWrap.lob;
                baseQuote.OpportunityId = dataWrap.opportunityId;
                baseQuote.Quote_Execution_Id__c = dataWrap.executionId;
                baseQuote.Carrier__c = dataWrap.carrier;
                baseQuote.Type__c = dataWrap.lob;
                baseQuote.Bundled_Auto_Quote__c = getParentQuote(dataWrap.parentExecutionId);
                baseQuote.Parent_Execution_Id__c = dataWrap.parentExecutionId;

                for(BaldwinQuoteResponseObj.Quotes quoteDataWrapp :dataWrap.quotes) {
                    Quote quote = baseQuote.clone(false, true, true, false);

                    quote.Policy_Term__c = String.isNotBlank(quoteDataWrapp.term) ? Integer.valueOf(quoteDataWrapp.term) : null ;
                    quote.Quoted_Premium__c = quoteDataWrapp.totalPremium;
                    quote.Quote_Number__c = quoteDataWrapp.id;
                    quote.Link_to_Bind__c = quoteDataWrapp.url;

                    boolean vcpProcessed = false;
                    if(quoteDataWrapp.details != null && !quoteDataWrapp.details.isEmpty()){
                        for(BaldwinQuoteResponseObj.Details detail : quoteDataWrapp.details){
                            if(detail.type == 'Coverage')
                                quote = populateValueOnQuote(quote,detail);
                            else if(detail.type.containsIgnoreCase('VehicleCoveragePremium'))
                                quote = populateVCPOnQuote(quote, detail);
                        }
                    }
                    if((quote.Type__c == 'Bundled' && String.isNotBlank(quote.Bundled_Auto_Quote__c)) || quote.Type__c != 'Bundled')
                        quoteList.add(quote);
                }
                
            }

            if(!quoteList.isEmpty())
            {
                System.debug('--- quote record: ' + json.serialize(quoteList));
                try
                {
                    upsert quoteList Quote_Execution_Id__c;

                    // Write Vertical Coverages
                    List<Quoted_Coverage__c> lstQuoted_Cov = new List<Quoted_Coverage__c>();
                    List<Quoted_Payment_Plan__c> lstPmtPlans = new List<Quoted_Payment_Plan__c>();
                    for(Integer i=0;i<quoteList.size();i++) {
                        if(!dataWrap.quotes[i].details.isEmpty()) {

                            Quoted_Payment_Plan__c pmtPlan = new Quoted_Payment_Plan__c(Quote__c=quoteList[i].Id);
                            for(BaldwinQuoteResponseObj.Details detail : dataWrap.quotes[i].details){

                                if(detail.type.containsIgnoreCase('coverage')) {
                                    Quoted_Coverage__c qv = new Quoted_Coverage__c();
                                    qv.Quote__c = quoteList[i].Id;
                                    qv.Coverage__c = detail.name; 
                                    qv.Limit__c = detail.limits;
                                    qv.Premium__c = detail.value;

                                    lstQuoted_Cov.add(qv);
                                }

                                if(detail.type.containsIgnoreCase('payment')) {

                                    switch on detail.name {
                                        when 'TotalAmount' {
                                            pmtPlan.put('Total_Amount__c', Decimal.valueOf(detail.value.replaceAll(',', '')));
                                        }
                                        when 'DownPayment' {
                                            pmtPlan.put('Down_Payment__c', Decimal.valueOf(detail.value.replaceAll(',', '')));
                                        }
                                        when 'InstallmentPayment' {
                                            if(detail.value != '-')
                                                pmtPlan.put('Installment_Payment__c', Decimal.valueOf(detail.value.replaceAll(',', '')));
                                        }
                                        when else {
                                            pmtPlan.put('Description__c', detail.value);
                                            lstPmtPlans.add(pmtPlan);
                                            pmtPlan = new Quoted_Payment_Plan__c(Quote__c=quoteList[i].Id);
                                        }
                                    }
                                }
                            }
                        }
                    }

                    if(!lstQuoted_Cov.isEmpty())
                        insert lstQuoted_Cov;
                    
                    if(!lstPmtPlans.isEmpty())
                        insert lstPmtPlans;

                    publishAyncToastEvent(quoteList[0].OpportunityId, quoteList[0].Carrier__c , 'Quote created successfully!', 'success', 'dismissible');
                }
                catch(Exception exec) {
                    System.debug('Error: ' + exec.getLineNumber() + ' | ' + exec);
                    publishAyncToastEvent(quoteList[0].OpportunityId, quoteList[0].Carrier__c, 'Error :' + exec.getMessage(), 'error', 'dismissible');

                    // Overwrite response values
                    response.statusCode = 500;
                    response.responseBody = blob.valueOf('Error in creating Quote' + exec.getMessage());
                }
            }
            else {
                Quote_Response_Reprocess__e rep = new Quote_Response_Reprocess__e();
                rep.Retry_Count__c = (attempt + 1);
                rep.Response_JSON__c = requestBody;

                if(rep.Retry_Count__c < 3) {
                    DateTime now = System.now();
                    while (now.addSeconds(10) > System.now()) {
                        continue;
                    }
                    EventBus.publish(rep);
                }
            }
        }

        return response;
    } 
    
    public static void publishAyncToastEvent(Id objectId, String title, String message, String type, String mode) {
        Async_Toast_Notification__e evt = new Async_Toast_Notification__e();
        evt.Object_Id__c = objectId;
        evt.Title__c = title;
        evt.Message__c = message;
        evt.Type__c = type;
        evt.Mode__c = mode;
        EventBus.publish(evt);
    }

    public static Quote populateValueOnQuote(Quote quote, BaldwinQuoteResponseObj.Details detail) {

        switch on detail.name {
            when 'BodilyInjury' { quote.Bodily_Injury_Liability__c = detail.value; }
            when 'BI' { quote.Bodily_Injury_Liability__c = detail.value; }
            when 'PropertyDamage' { quote.Auto_Property_Damage__c = detail.value; }
            when 'PD' { quote.Auto_Property_Damage__c = detail.value; }
            when 'UninsuredMotorist' {quote.Uninsured_Motorist_Bodily__c = detail.value;}
            when 'UM' {quote.Uninsured_Motorist_Bodily__c = detail.value;}
            when 'UnderinsuredMotorist' {quote.Uninsured_Motorist_Property__c = detail.value; }
            when 'UIM' {quote.Uninsured_Motorist_Property__c = detail.value; }
            when 'PersonalInjuryProtection' { quote.Personal_Injury_Protection__c = getDecimals(detail.value);}
            when 'PIP Deductible' { quote.Personal_Injury_Protection__c = getDecimals(detail.value);}
            when 'MotoristProperty' {quote.Motorist_Property_Limit__c = detail.value;
                                     quote.Motorist_Property_Limit__c = detail.limits;}
            when 'UninsuredMotoristPropertyDamage' { quote.UMPD__c = getDecimals(detail.value);}
            
            when 'Collision' {quote.Collision_Deductible__c = detail.value;
                              quote.Collision_Limit__c = getDecimals(detail.limits);}
            when 'Comprehensive' {quote.Comprehensive_Deductible__c = Integer.valueOf(detail.limits);
                                  quote.Comprehensive_Limit__c = getDecimals(detail.limits);}
            // HOME VALUES
            when 'Deductible' {quote.Home_Insurance_Deductible__c = getDecimals(detail.value); }
            when 'Dwelling' {quote.Dwelling_Coverage__c = getDecimals(detail.value); }
            when 'PersonalLiability' {quote.Liability_Coverage__c = getDecimals(detail.value); }
            when 'PersonalProperty' { quote.Personal_Property__c = getDecimals(detail.value); }
            when 'WindDeductible' { quote.Wind_Hail_Deductible__c = detail.value; }
        }
        return quote;
    }

    public static Quote populateVCPOnQuote(Quote quote, BaldwinQuoteResponseObj.Details detail) {
        
        switch on detail.name {
            when 'Collision' {
                quote.Collision_Deductible__c = detail.limits;
            }
            when 'Comprehensive' {
                if(!String.isBlank(detail.limits) && quote.Comprehensive_Deductible__c == null) {
                    quote.Comprehensive_Deductible__c = Integer.valueOf(detail.limits);
                    quote.Comprehensive_Limit__c = Integer.valueOf(detail.limits);
                }
            }
            when 'PIP Deductible' {
                if(detail.limits != null)
                    quote.Comprehensive_Deductible__c = Integer.valueOf(detail.limits);
            }
            when 'Ext Trans Expense' { quote.Rental_Reimbursement__c = detail.limits;}
            when 'Towing & Labor' { quote.Roadside_Assistance__c = detail.limits;}
        }
        
        return quote;
    }
     
    public static Decimal getDecimals(String value) {
        if(String.isBlank(value))
            return null;

        try
        {
            return decimal.valueOf(value.remove('$').remove(','));
        }
        catch(Exception exec) {
            System.debug('Error: The value "' + value + '" can be converted to decimal');
        }

        return null;
    }

    private static Id getParentQuote(Integer quoteExecutionId) {
        System.debug('--- quoteExecutionId: ' + quoteExecutionId);
        try {
            Quote parent = [SELECT Id FROM Quote WHERE Quote_Execution_Id__c = :quoteExecutionId];
            System.debug('--- quote: ' + json.serialize(parent) );
            if(parent?.Id == null)
                throw new WebserviceException();
            return parent?.Id;
        } catch (Exception e) {
            System.debug('--- NO PARENT QUOTE FOUND');
        }
        return null;
    }

    class WebserviceException extends Exception {} 
}