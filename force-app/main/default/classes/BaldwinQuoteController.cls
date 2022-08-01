public class BaldwinQuoteController {
    
    @InvocableMethod(label='Request Quote' description='callout to Baldwin API' category='Property')
    public static void requestQuote(List<flowInputvalues> inputs){
        System.debug('propertyIds' + inputs);
        
        if(inputs != null && !inputs.isEmpty()){
            
            flowInputvalues wrapData =  inputs[0];
            Id oppId = wrapData.oppId;
            List<Property__c> listProperties = fetchProperties(wrapData.relatedPropertyIds);
            String requestBody;
            
            String requestType = getRequestType(listProperties);
            System.debug('requestType' + requestType);
            if(requestType == 'AutoQuote'){
                BaldwinQuoteObj.AutoQuote requestObj = buildAutoQuoteRequest(oppId, listProperties);
                requestBody = json.serialize(requestObj, true);
                requestBody = requestBody.replace('date1', 'date');
            }else if(requestType == 'HomeQuote'){
                BaldwinQuoteObj.HomeQuote requestObj = buildHomeQuoteRequest(oppId, listProperties);
                requestBody = json.serialize(requestObj, true);
                requestBody = requestBody.replace('date1', 'date');
            }else if(requestType == 'BundledQuote'){
                BaldwinQuoteObj.BundledQuote requestObj = buildBundledQuoteRequest(oppId, listProperties);
                requestBody = json.serialize(requestObj, true);
                requestBody = requestBody.replace('date1', 'date');
            }           
            System.debug('requestBody' + requestBody);
            HttpResponse response = makeAPICallout(requestBody);
            System.debug('response' + response);            
            System.debug('response body = ' + response.getBody());
            
            if(response.getStatusCode() != 200){
                String errormessage = '['+response.getStatusCode() + ' - ' + response.getStatus()+']' + response.getBody();
                throw new BaldwinQuoteException(errormessage);
            }
        }
    }
    
    private static String getRequestType(List<Property__c> listProperties){
        String requestType;
        Boolean hasHomeType = false, hasAutoType = false;
        for(Property__c property : listProperties){
            if(property.RecordType.Name == 'Auto'){
                hasAutoType = true;
            }
            if(property.RecordType.Name == 'Home'){
                hasHomeType = true;
            }
        }
        if(hasHomeType && hasAutoType){
            requestType = 'BundledQuote';
        }else if(hasHomeType){
            requestType = 'HomeQuote';
        }else if(hasAutoType){
            requestType = 'AutoQuote';
        }
        return requestType;
    }
    
    private static BaldwinQuoteObj.HomeQuote buildHomeQuoteRequest(Id oppId, List<Property__c> listProperties){

        Opportunity opp = [SELECT Id, AccountId, Co_Applicant__c, Owner.Operating_Department__c
                           FROM Opportunity 
                           WHERE ID =: oppId];

        BaldwinQuoteObj.HomeQuote requestObj = new BaldwinQuoteObj.HomeQuote();
        requestObj.opportunityId = oppId;
        requestObj.brpGroup = opp.Owner.Operating_Department__c;
        requestObj.dwelling = BaldwinQuoteObj.getDwelling(listProperties[0]);
        requestObj.policyInfo = BaldwinQuoteObj.getPolicyInfo(listProperties[0]);
        requestObj.applicants = BaldwinQuoteObj.getApplicants(getHomeApplicants(opp), opp.accountId);

        System.debug('-- quote obj:' + requestObj);

        return requestObj;
    }
    
    private static BaldwinQuoteObj.AutoQuote buildAutoQuoteRequest(Id oppId, List<Property__c> listProperties){

        Opportunity opp = [SELECT Id, AccountId, Account.RecordType.Name, Account.PersonContactId,
                           Owner.Operating_Department__c
                           FROM Opportunity 
                           WHERE ID =: oppId];
        List<Driver__c> lstDrivers = fetchDrivers(listProperties);

        BaldwinQuoteObj.AutoQuote requestObj = new BaldwinQuoteObj.AutoQuote();
        requestObj.opportunityId = oppId;
        requestObj.brpGroup = opp.Owner.Operating_Department__c;
        requestObj.generalCoverages = BaldwinQuoteObj.getGeneralCoverages(listProperties[0]);
        requestObj.vehicles = BaldwinQuoteObj.getVehicles(listProperties, lstDrivers);
        requestObj.drivers = BaldwinQuoteObj.getDrivers(lstDrivers, opp.Account.PersonContactId);
        requestObj.priorPolicy = BaldwinQuoteObj.getPriorPolicy(listProperties[0]);

        return requestObj;
    }
    
    private static BaldwinQuoteObj.BundledQuote buildBundledQuoteRequest(Id oppId, List<Property__c> listProperties){
        
        Opportunity opp = [SELECT Id, AccountId, Account.RecordType.Name, Account.PersonContactId,
                           Owner.Operating_Department__c
                           FROM Opportunity 
                           WHERE ID =: oppId];
        List<Driver__c> lstDrivers = fetchDrivers(listProperties);

        BaldwinQuoteObj.BundledQuote requestObj = new BaldwinQuoteObj.BundledQuote();
        requestObj.opportunityId = oppId;
        requestObj.brpGroup = opp.Owner.Operating_Department__c;
        requestObj.vehicles = BaldwinQuoteObj.getVehicles(listProperties, lstDrivers);
        for(Property__c prop: listProperties) {
            if(prop.RecordType.Name.containsIgnoreCase('auto')) {
                requestObj.priorPolicy = BaldwinQuoteObj.getPriorPolicy(listProperties[0]);
                break;
            }
        }
        requestObj.drivers = BaldwinQuoteObj.getDrivers(lstDrivers, opp.Account.PersonContactId);
        requestObj.dwelling = BaldwinQuoteObj.getDwellingFromList(listProperties);
        requestObj.homePolicyInfo = BaldwinQuoteObj.getPolicyInfo(listProperties[0]);

        return requestObj;
    }   
    
    private static List<Property__c> fetchProperties(List<String> relatedpropertyIds){
        List<Property__c> listProperties = new List<Property__c>();
        if(relatedpropertyIds != null && !relatedpropertyIds.isEmpty()){
            Set<Id> setPropertyIds = new Set<Id>();
            for(String propertyId: relatedpropertyIds){
                if(String.isNotBlank(propertyId)){
                    setPropertyIds.add(propertyId);
                }
            }

            listProperties = [SELECT Id, Name, Recordtype.Name, Account__c, 
                              UseVin_Lookup__c, VIN__c, Vehicle_Make__c, Vehicle_Model__c, 
                              Vehicle_Sub_Model__c, Purchase_Date__c, One_Way_Miles__c, 
                              Annual_Miles__c, Own_or_Rent_Vehicle__c, Principal_Operator__c, 
                              Collision_Deductible__c, Rental_Cost__c, 
                              /*Policy_Effective__c,*/ Dwelling_Type__c, Number_of_Occupants__c,
                              Dwelling_Usage__c, Year_Built__c, Square_Footage__c, 
                              Purchase_Price__c, Type_of_Construction__c,Structure_Type__c,
                              Substructure__c, Roof_Material__c, Roof_Design__c,Roof_Type__c,RoofDesign__c, 
                              Address_Line_1__c, Address_Line_2__c, City__c, State__c,Dwelling_Under_Construction__c,Dog_Breed_Type__c,
                              Zip_Code__c, Former_Carrier__c, Former_Policy_Expiration__c,Year_Roof_Installed__c,Year_Electrical_Update__c,Year_Plumbing_Update__c,Year_Heating_Update__c,
                              Vehicle_ID__c, Applicant_Type__c, BI_Coverage_Needed__c,Swimming_Pool_Type__c,Construction_Type__c,
                              Foundation_Type__c, Replacement_Cost__c, Uninsured_Motorist__c, County__c, Vehicle_Use__c,All_Other_Perils_Deductible__c,Hurricane_Deductible__c,Personal_Liability__c,Medical_Payments__c,
							  Personal_Property_Replacement_Cost__c,Bodily_Injury_Liability__c,Property_Damage__c,Uninsured_Motorist_Liability__c,No_of_stories__c	,
							  Comp_Deductible__c,Collision_Deductible_PL__c,Towing_Labor__c,Rental_Reimbursement_Ext_Trans_Expense__c,Heating_Type__c, No_of_FullBaths__c,No_of_HalfBaths__c,
                                (SELECT Driver__c, Driver__r.Driver_Contact__c, Primary_Driver__c
                                    FROM Assigned_Drivers__r)
                              FROM Property__c
                              WHERE ID IN :setPropertyIds];
        }
        return listProperties;
    }
    
    private static List<Driver__c> fetchDrivers(List<Property__c> relatedproperties){
        
        List<Driver__c> listDrivers = [SELECT Id, First_Name__c, Last_Name__c, 
                                       License_State__c,  Driver_License_Status__c, Birthdate__c, 
                                       License_Number__c, Marital_Status__c, 
                                       CompLoss_Date__c, CompLoss_Description__c,
                                       CompLoss_Value__c, Incident_Code_1__c, Incident_Date_1__c, 
                                       Incident_1_Description__c, Incident_1_PD__c, 
                                       Incident_1_BI__c, Violation_Date__c, Violation_Description__c, Driver_Contact__c,
                                       Driver_Contact__r.MailingState, Driver_Contact__r.MailingCity, 
                                       Driver_Contact__r.MailingCountry, Driver_Contact__r.Mailing_County__c,
                                       Driver_Contact__r.Mailingpostalcode, 
                                       Driver_Contact__r.MailingStreet, Driver_Contact__r.Suffix, 
                                       Driver_Contact__r.Birthdate, Driver_Contact__r.email, 
                                       Driver_Contact__r.firstname, Driver_Contact__r.lastname,  Driver_Contact__r.SSN__c,
                                       Driver_Contact__r.FinServ__Gender__c, Driver_Contact__r.Phone, License_Date__c,
                                       Driver_Contact__r.Account.Industry, Driver_Contact__r.Account.Occupation__c
                                       FROM Driver__c 
                                       WHERE Id IN (SELECT Driver__c 
                                                     FROM Assigned_Driver__c
                                                     WHERE Property__c IN : relatedproperties )];
        return listDrivers;
    }
    
    private static HttpResponse makeAPICallout(String body){
        HttpRequest req = new HttpRequest();
        
        String trackingId = generateTrackingId();

        System.debug('--- Tracking Id: ' + trackingId);
        System.debug('--- Request Body: ' + body);

        String endPoint = config.Endpoint__c ;
        req.setEndPoint(endPoint);
        req.setHeader('Accept','application/json, text/plain');
        req.setHeader('Content-Type','application/json;charset=utf-8');
        req.setHeader('correlationId', trackingId);
        req.setHeader('client_id',config.Integration_Auth__r.Client_Id__c);
        req.setHeader('client_secret',config.Integration_Auth__r.Client_Secret__c );
        
        req.setMethod('POST');
        req.setBody(body);
        req.setTimeout(120000);
        
        Http httpObj = new Http();
        HttpResponse res = httpObj.send(req);        
        return res;
    }

    private static String generateTrackingId() {
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);

        return h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
    }
    
    private static Integration_Endpoint__mdt config {
        get
        {
            return [SELECT MasterLabel,
                    Endpoint__c,
                    Integration_Auth__r.Client_Id__c,
                    Integration_Auth__r.Client_Secret__c
                    FROM Integration_Endpoint__mdt
                    WHERE MasterLabel = 'Request Quote'];
        }
    }

    public static List<Account> getHomeApplicants(Opportunity opp) {
        
        Set<Id> setPersonAccountIds = new Set<Id>();
        setPersonAccountIds.add(opp.accountId);
        if(opp.Co_Applicant__c != null){
            setPersonAccountIds.add(opp.Co_Applicant__c);
        }
        
        return [SELECT Id, Firstname, LastName, MiddleName, PersonEmail, 
                Salutation, suffix, PersonBirthdate, FinServ__Gender__pc,
                PersonHomePhone, PersonMobilePhone, FinServ__Occupation__pc, 
                FinServ__MaritalStatus__pc, Phone, PersonMailingAddress,  PersonMailingStreet, 
                PersonMailingCity,  PersonMailingState,  PersonMailingPostalCode,
                PersonMailingCountry, Mailing_County__pc, Industry, Occupation__c
                FROM Account
                WHERE Id In :setPersonAccountIds Limit 2];
    }
    
    public class flowInputvalues{
        @invocablevariable
        public string oppId;
        
        @invocablevariable
        public list<String> relatedpropertyIds;
    }
    
    public class BaldwinQuoteException extends Exception{}
}