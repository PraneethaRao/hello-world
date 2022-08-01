@isTest
public class AccountCreateHouseholdTest {
	static final Id PERSONACCT_RECORDTYPE = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    
    @isTest static void testCreate(){
    	Account a = new Account(Firstname='Test', LastName='Record', recordtypeid=PERSONACCT_RECORDTYPE, Create_Household__c=true);
    	insert a;
        
        List<AccountContactRelation> acr = [SELECT ID FROM AccountContactRelation];
        system.assertEquals(true, acr.size() > 0);
        
    }
}