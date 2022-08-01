@isTest
public class BaldwinEnrichmentControllerTest {

    Static Final Id PersonAcc_RT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    Static Final Id HomeProperty_RT = Schema.SObjectType.Property__c.getRecordTypeInfosByName().get('Home').getRecordTypeId();
    Static Final Id AutoProperty_RT = Schema.SObjectType.Property__c.getRecordTypeInfosByName().get('Auto').getRecordTypeId();
    Static Final Id Lead_RT = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Person Lead').getRecordTypeId();
    
    @isTest static void testRequestEnrichmentHome(){
    	
        Id propId = getProperty(HomeProperty_RT);        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());        
        Test.startTest();
        
        BaldwinEnrichmentController.requestEnrichment(propId);
        
        test.stopTest();
    }
    
    @isTest static void testRequestEnrichmentAuto(){
    	
        Id propId = getProperty(AutoProperty_RT);        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
        
        String mesg = BaldwinEnrichmentController.requestEnrichment(propId);
        
        test.stopTest();
        
        System.assertEquals('Success', mesg);
    }

    @isTest static void testRequestEnrichmentIncoable(){
    	
        // Id propId = getProperty(AutoProperty_RT);
        List<String> lStr = new List<String>{getProperty(AutoProperty_RT)};
        List<List<String>> lStr2 = new List<List<String>>{lStr};
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
            BaldwinEnrichmentController.invocableEnrichmentRequest(lStr2);
        test.stopTest();
    }
    
        @isTest static void testRequestEnrichmentLeadIncoable(){
    	
        // Id propId = getProperty(AutoProperty_RT);
        List<String> lStr = new List<String>{getLead(Lead_RT)};
        List<List<String>> lStr2 = new List<List<String>>{lStr};
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
            BaldwinEnrichmentController.invocableEnrichmentRequest(lStr2);
        test.stopTest();
    }
    
     @isTest static void testrequestLeadHomeEnrichment(){
    	
        Id propId = getLead(Lead_RT);        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());        
        Test.startTest();
        
        BaldwinEnrichmentController.requestLeadHomeEnrichment(propId);
        
        test.stopTest();
    }
    
     @isTest static void testrequestLeadHomeEnrichmentFail(){
    	
        Id propId = getLead(Lead_RT);        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorFail());        
        Test.startTest();
        
        BaldwinEnrichmentController.requestLeadHomeEnrichment(propId);
        
        test.stopTest();
    }
    
    
    public static String getProperty(Id recordTypeId){
        
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
        
        Property__c prop = new Property__c();
        prop.Account__c = accRec.Id;
        prop.RecordTypeId = recordTypeId;
        prop.VIN__c = '54135624';
        insert prop;
        
        return prop.Id;
    }
    
    public static String getLead(Id recordTypeId){
        
        Lead ld = new Lead();
        ld.RecordTypeId = recordTypeId;
        ld.FirstName ='TestLead';
        ld.LastName ='TestLN';
        ld.Policy_Type__c='Home';
        ld.FinServ__ExpressedInterest__c='Personal Lines';
        ld.LeadSource='Datalot';
        ld.Street='3244 Quinn Street';
        ld.City='Rochester Hills';
        ld.State='MI';
        ld.Country='United States';
        ld.County__c='Oakland';
        insert ld;
        
        return ld.Id;
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
    
    public class MockHttpResponseGeneratorFail implements HttpCalloutMock {
       
        public HTTPResponse respond(HTTPRequest req) {
           
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"example":"test"}');
            res.setStatusCode(500);
            return res;
        }
    }
}