@isTest
public class BaldwinAsyncQuoteWebserviceTest {

    Static Final Id PersonAcc_RT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();

    @TestSetup
    static void makeData(){
        Account accRec = new Account(Firstname='Test 1', LastName='Record');
        accRec.Create_Household__c = true;
        accRec.PersonEmail = 'test1@test.com';
        accRec.RecordTypeId = PersonAcc_RT;
        accRec.PersonBirthdate = system.today().addyears(-20); 
        accRec.PersonMailingStreet = '9876 Lyndhurst Street';
        accRec.PersonMailingCity = 'Oakland';
        accRec.PersonMailingState = 'CA';
        accRec.PersonMailingCountry = 'United States';
        accRec.PersonMailingPostalCode = '94603';
        accRec.PersonHomePhone = '946012323';
        insert accRec;
        
        Product2 prod1 = new Product2();
        prod1.name = 'test product 1';
        insert prod1;
        
        Opportunity oppRec = new Opportunity();
        oppRec.Name = 'test Opp 1';
        oppRec.AccountId = accRec.Id;
        oppRec.CloseDate = System.today();
        oppRec.StageName = 'Discovery';
        oppRec.Line_of_Business__c = prod1.Id;
        insert oppRec;
    }

    @isTest 
    static void testHandleQuoteWithError(){

        Opportunity o = [SELECT Id FROM Opportunity WHERE Name = 'test Opp 1' LIMIT 1];
        
        Test.startTest();
            String requestBody = getQuoteRequestBodyError(o.Id);
            RestRequest req = new RestRequest();
            req.requestBody = Blob.valueOf(requestBody);
            req.httpMethod = 'POST';
            RestContext.request = req;
            BaldwinAsyncQuoteWebservice.handleQuote();
        Test.stopTest();
        
        // List<Quote> lstQuote = [SELECT Id FROM Quote WHERE OpportunityId =: o.Id];
        // System.assertEquals(1, lstQuote.size());
    }

    @isTest 
    static void testHandleQuote(){

        Opportunity o = [SELECT Id FROM Opportunity WHERE Name = 'test Opp 1' LIMIT 1];

        Test.startTest();
            String requestBody = getQuoteRequestBody(o.Id);
            RestRequest req = new RestRequest();
            req.requestBody = Blob.valueOf(requestBody);
            req.httpMethod = 'POST';
            RestContext.request = req;
            BaldwinAsyncQuoteWebservice.handleQuote();
        Test.stopTest();

        List<Quote> lstQuote = [SELECT Id FROM Quote WHERE OpportunityId =: o.Id];
        System.assertEquals(1, lstQuote.size());
    }

    @isTest
    static void testRetryPlatformEvent(){

        Opportunity o = [SELECT Id FROM Opportunity WHERE Name = 'test Opp 1' LIMIT 1];

        Test.startTest();
            Quote_Response_Reprocess__e rep = new Quote_Response_Reprocess__e();
            rep.Retry_Count__c = 1;
            rep.Response_JSON__c =  getQuoteRequestBody(o.Id);

            EventBus.publish(rep);
        Test.stopTest();

    }
    
    private static String getQuoteRequestBody(Id oppId){
        String jsonString = '{'+
        '    "executionId": "21616656",'+
        '    "OpportunityId":"'+oppId+'",'+
        '    "status": "Succeeded",'+
        '    "carrier": "American Integrity",'+
        '    "lob": "Home",'+
        '    "completion": 100,'+
        '    "message": "Total Premium : $6,519.00 Quote Number: QT-00018639     ",'+
        '    "quotes": ['+
        '        {'+
        '            "id": "QT-00018639",'+
        '            "package": false,'+
        '            "status": "Rated",'+
        '            "term": "12",'+
        '            "premium": 6519.00,'+
        '            "totalPremium": 6519.00,'+
        '            "url": null,'+
        '            "creditScored": "Yes",'+
        '            "details": ['+
        '                {'+
        '                    "type": "Coverage",'+
        '                    "name": "NumberOfFamilies",'+
        '                    "value": "One Family",'+
        '                    "limits": null'+
        '                },'+
        '                {'+
        '                    "type": "Coverage",'+
        '                    "name": "Deductible",'+
        '                    "value": "1000",'+
        '                    "limits": null'+
        '                },'+
        '                {'+
        '                    "type": "Coverage",'+
        '                    "name": "TheftDeductible",'+
        '                    "value": "None",'+
        '                    "limits": null'+
        '                },'+
        '                {'+
        '                    "type": "Coverage",'+
        '                    "name": "WindDeductible",'+
        '                    "value": "2%",'+
        '                    "limits": null'+
        '                },'+
        '                {'+
        '                    "type": "Coverage",'+
        '                    "name": "ReplacementCost",'+
        '                    "value": "$500,000",'+
        '                    "limits": null'+
        '                },'+
        '                {'+
        '                    "type": "Coverage",'+
        '                    "name": "Dwelling",'+
        '                    "value": "$500,000",'+
        '                    "limits": null'+
        '                },'+
        '                {'+
        '                    "type": "Coverage",'+
        '                    "name": "OtherStructures",'+
        '                    "value": "$25,000",'+
        '                    "limits": null'+
        '                },'+
        '                {'+
        '                    "type": "Coverage",'+
        '                    "name": "PersonalProperty",'+
        '                    "value": "$200,000",'+
        '                    "limits": null'+
        '                },'+
        '                {'+
        '                    "type": "Coverage",'+
        '                    "name": "LossOfUse",'+
        '                    "value": "$50,000",'+
        '                    "limits": null'+
        '                },'+
        '                {'+
        '                    "type": "Coverage",'+
        '                    "name": "PersonalLiability",'+
        '                    "value": "$300,000",'+
        '                    "limits": null'+
        '                },'+
        '                {'+
        '                    "type": "Coverage",'+
        '                    "name": "MedicalPayments",'+
        '                    "value": "$5,000",'+
        '                    "limits": null'+
        '                },'+
        '                {'+
        '                    "type": "RatingMessages",'+
        '                    "name": "Message",'+
        '                    "value": "Ordinance or Law Of 10% is been added to the quote.",'+
        '                    "limit": null'+
        '                },'+
        '                {'+
        '                    "type": "PaymentPlans",'+
        '                    "name": "TotalAmount",'+
        '                    "value": "6519.00",'+
        '                    "limit": null'+
        '                },'+
        '                {'+
        '                    "type": "PaymentPlans",'+
        '                    "name": "Description",'+
        '                    "value": "Total Premium",'+
        '                    "limit": null'+
        '                },'+
        '                {'+
        '                    "type": "PaymentPlans",'+
        '                    "name": "TotalAmount",'+
        '                    "value": "6,594.00",'+
        '                    "limit": null'+
        '                },'+
        '                {'+
        '                    "type": "PaymentPlans",'+
        '                    "name": "DownPayment",'+
        '                    "value": "1650.00",'+
        '                    "limit": null'+
        '                },'+
        '                {'+
        '                    "type": "PaymentPlans",'+
        '                    "name": "InstallmentPayment",'+
        '                    "value": "1648.00",'+
        '                    "limit": null'+
        '                },'+
        '                {'+
        '                    "type": "PaymentPlans",'+
        '                    "name": "Description",'+
        '                    "value": "4 Pay Payment Plan",'+
        '                    "limit": null'+
        '                },'+
        '                {'+
        '                    "type": "PaymentPlans",'+
        '                    "name": "TotalAmount",'+
        '                    "value": "6,594.00",'+
        '                    "limit": null'+
        '                },'+
        '                {'+
        '                    "type": "PaymentPlans",'+
        '                    "name": "DownPayment",'+
        '                    "value": "2623.80",'+
        '                    "limit": null'+
        '                },'+
        '                {'+
        '                    "type": "PaymentPlans",'+
        '                    "name": "InstallmentPayment",'+
        '                    "value": "1323.40",'+
        '                    "limit": null'+
        '                },'+
        '                {'+
        '                    "type": "PaymentPlans",'+
        '                    "name": "Description",'+
        '                    "value": "Quarterly Payment Plan",'+
        '                    "limit": null'+
        '                },'+
        '                {'+
        '                    "type": "PaymentPlans",'+
        '                    "name": "TotalAmount",'+
        '                    "value": "6,569.00",'+
        '                    "limit": null'+
        '                },'+
        '                {'+
        '                    "type": "PaymentPlans",'+
        '                    "name": "DownPayment",'+
        '                    "value": "3922.20",'+
        '                    "limit": null'+
        '                },'+
        '                {'+
        '                    "type": "PaymentPlans",'+
        '                    "name": "InstallmentPayment",'+
        '                    "value": "2646.80",'+
        '                    "limit": null'+
        '                },'+
        '                {'+
        '                    "type": "PaymentPlans",'+
        '                    "name": "Description",'+
        '                    "value": "Semi-Annual Payment Plan",'+
        '                    "limit": null'+
        '                },'+
        '                {'+
        '                    "type": "PaymentPlans",'+
        '                    "name": "TotalAmount",'+
        '                    "value": "6,519.00",'+
        '                    "limit": null'+
        '                },'+
        '                {'+
        '                    "type": "PaymentPlans",'+
        '                    "name": "DownPayment",'+
        '                    "value": "6519.00",'+
        '                    "limit": null'+
        '                },'+
        '                {'+
        '                    "type": "PaymentPlans",'+
        '                    "name": "InstallmentPayment",'+
        '                    "value": "-",'+
        '                    "limit": null'+
        '                },'+
        '                {'+
        '                    "type": "PaymentPlans",'+
        '                    "name": "Description",'+
        '                    "value": "Full Payment Plan",'+
        '                    "limit": null'+
        '                },'+
        '                {'+
        '                    "type": "PaymentPlans",'+
        '                    "name": "TotalAmount",'+
        '                    "value": "6,561.00",'+
        '                    "limit": null'+
        '                },'+
        '                {'+
        '                    "type": "PaymentPlans",'+
        '                    "name": "PersonalInjuryProtection",'+
        '                    "value": "1520.16",'+
        '                    "limit": null'+
        '                },'+
        '                {'+
        '                    "type": "PaymentPlans",'+
        '                    "name": "InstallmentPayment",'+
        '                    "value": "720.12",'+
        '                    "limit": null'+
        '                },'+
        '                {'+
        '                    "type": "PaymentPlans",'+
        '                    "name": "Description",'+
        '                    "value": "8 Pay Payment Plan",'+
        '                    "limit": null'+
        '                },'+
        '                {'+
        '                    "type": "HomeCoveragePremium",'+
        '                    "name": "Dwelling",'+
        '                    "value": null,'+
        '                    "limit": "$500,000"'+
        '                },'+
        '                {'+
        '                    "type": "HomeCoveragePremium",'+
        '                    "name": "OtherStructures",'+
        '                    "value": null,'+
        '                    "limit": "$25,000"'+
        '                },'+
        '                {'+
        '                    "type": "HomeCoveragePremium",'+
        '                    "name": "LossOfUse",'+
        '                    "value": null,'+
        '                    "limit": "$50,000"'+
        '                },'+
        '                {'+
        '                    "type": "HomeCoveragePremium",'+
        '                    "name": "PersonalProperty",'+
        '                    "value": null,'+
        '                    "limit": "$200,000"'+
        '                },'+
        '                {'+
        '                    "type": "HomeCoveragePremium",'+
        '                    "name": "PersonalLiability",'+
        '                    "value": null,'+
        '                    "limit": "$300,000"'+
        '                },'+
        '                {'+
        '                    "type": "HomeCoveragePremium",'+
        '                    "name": "MedicalPayments",'+
        '                    "value": null,'+
        '                    "limit": "$5,000"'+
        '                },'+
        '                {'+
        '                    "type": "EndorsementPremium",'+
        '                    "name": "Deductible",'+
        '                    "value": null,'+
        '                    "limit": "$10.00"'+
        '                },'+
        '                {'+
        '                    "type": "EndorsementPremium",'+
        '                    "name": "IncreasedMold",'+
        '                    "value": null,'+
        '                    "limit": "$10,000"'+
        '                },'+
        '                {'+
        '                    "type": "EndorsementPremium",'+
        '                    "name": "LossAssessment",'+
        '                    "value": null,'+
        '                    "limit": "$1,000"'+
        '                },'+
        '                {'+
        '                    "type": "EndorsementPremium",'+
        '                    "name": "OrdinanceOrLaw",'+
        '                    "value": null,'+
        '                    "limit": "$50,000"'+
        '                },'+
        '                {'+
        '                    "type": "EndorsementPremium",'+
        '                    "name": "Limited Carport(s), Pool Cage(s), and Screen Enclosure(s)",'+
        '                    "value": null,'+
        '                    "limit": "$10,000"'+
        '                }'+
        '            ]'+
        '        }'+
        '    ]'+
        '}';
        return jsonString;
    }

    private static String getQuoteRequestBodyError(Id oppId){
        String jsonString = '{'+
        '    "executionId": "21616656",'+
        '    "OpportunityId":"'+oppId+'",'+
        '    "status": "Error",'+
        '    "carrier": "American Integrity",'+
        '    "lob": "Home",'+
        '    "completion": 100,'+
        '    "message": "Total Premium : $6,519.00 Quote Number: QT-00018639     ",'+
        '    "quotes": null ' +
        '}';

        return jsonString;
    }
}