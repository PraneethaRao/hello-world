@isTest
public class BaldwinQuoteControllerTest {
    
    Static Final Id PersonAcc_RT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    Static Final Id HomeProperty_RT = Schema.SObjectType.Property__c.getRecordTypeInfosByName().get('Home').getRecordTypeId();
    Static Final Id AutoProperty_RT = Schema.SObjectType.Property__c.getRecordTypeInfosByName().get('Auto').getRecordTypeId();
    
    @isTest static void testRequestQuote(){
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
        
        Account accRec2 = new Account(Firstname='Test 2', LastName='Record');
        accRec2.Create_Household__c = false;
        accRec2.PersonEmail = 'test2@test.com';
        accRec2.RecordTypeId = PersonAcc_RT;
        accRec2.PersonBirthdate = system.today().addyears(-20);
        accRec2.Phone = '946012323';
    	insert accRec2;
        
        Product2 prod1 = new Product2();
        prod1.name = 'test product 1';
        insert prod1;
        
        Opportunity oppRec = new Opportunity();
        oppRec.Name = 'test Opp 1';
        oppRec.AccountId = accRec.Id;
        oppRec.Co_Applicant__c = accRec2.Id;
        oppRec.CloseDate = System.today();
        oppRec.StageName = 'Discovery';
		oppRec.Line_of_Business__c = prod1.Id;
        insert oppRec;
        
        Property__c propHome = new Property__c();
        propHome.Account__c = accRec.Id;
        propHome.RecordTypeId = HomeProperty_RT;
        insert propHome;
        
        Property__c propAuto = new Property__c();
        propAuto.Account__c = accRec.Id;
        propAuto.RecordTypeId = AutoProperty_RT;
        insert propAuto;
        
        Id  personContactId = [SELECT ID, PersonContactId FROM Account WHERE ID =: accRec2.Id].PersonContactId;
        
        Driver__c driver = new Driver__c();
        driver.Driver_Contact__c = personContactId;
        insert driver;
        
        Assigned_Driver__c asDriver = new Assigned_Driver__c();
        asDriver.Property__c = propAuto.Id;
        asDriver.Driver__c = driver.Id;
        insert asDriver;
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());        
        
        Test.startTest();
        
        BaldwinQuoteController.flowInputvalues inp = new BaldwinQuoteController.flowInputvalues();
        inp.oppId = oppRec.Id; 
        //Test for Home quote
        inp.relatedPropertyIds = new List<String>{propHome.Id};
        BaldwinQuoteController.requestQuote(new List<BaldwinQuoteController.flowInputvalues>{inp});
        
        //Test for auto quote
        inp.relatedPropertyIds = new List<String>{propAuto.Id};
        BaldwinQuoteController.requestQuote(new List<BaldwinQuoteController.flowInputvalues>{inp});
        
        //Test for Home and auto quote
        inp.relatedPropertyIds = new List<String>{propAuto.Id, propHome.Id};
        BaldwinQuoteController.requestQuote(new List<BaldwinQuoteController.flowInputvalues>{inp});
        
        test.stopTest();
    }
    
    
    public class MockHttpResponseGenerator implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest req) {
           
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"example":"test"}');
            res.setStatusCode(200);
            return res;
        }
    }

}