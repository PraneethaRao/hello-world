public class AccountCreateHousehold {
    static final Id HOUSEHOLD_RECORDTYPE = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('IndustriesHousehold').getRecordTypeId();
	
    public static void create(List<Account> accounts){
        // ONLY SELECT ACCOUNTS THAT REQUIRE A HOUSEHOLD
        List<Account> accts = new List<Account>();
        for(Account thisacct :accounts){
            if(thisacct.Household__c == null && thisacct.Create_Household__c && thisacct.PersonContactId != null){
                accts.add(thisacct);
            }
        }
        system.debug('ACCTS: ' + accts.size());   

        //CREATE HOUSEHOLDS
        List<Account> hhNew = new List<Account>();
        for(Integer i=0; i < accts.size(); i++){
            hhNew.add(createHousehold(accts[i]));
        }
        insert hhNew;
        system.debug('HH: ' + hhNew.size());         

        // CREATE RELATIONSHIPS
        List<AccountContactRelation> acrList = new List<AccountContactRelation>();
        for(Integer i = 0; i < hhNew.size(); i++) {
            AccountContactRelation rel = new AccountContactRelation(
                    					AccountId = hhNew[i].Id, ContactId = accts[i].PersonContactId, FinServ__PrimaryGroup__c = true, 
                						FinServ__Rollups__c='All', FinServ__Primary__c = true, Roles='Client');
        acrList.add(rel); 
        }
        insert acrList;
        system.debug('RELATIONSHIP LIST: ' + acrList.size());  
        
    }
       
    private static Account createHousehold(Account a){
        LeadCreateHouseholdConfig__mdt lch = New LeadCreateHouseholdConfig__mdt();
        lch = [SELECT id, MasterLabel, Household_Name_Format__c FROM LeadCreateHouseholdConfig__mdt LIMIT 1];
        
        if(lch.Household_Name_Format__c == 'John & Jane Smith Household'){
        		return new Account(Name = a.FirstName + ' ' + a.LastName + ' Household', RecordTypeId = HOUSEHOLD_RECORDTYPE);   
        }else if(lch.Household_Name_Format__c == 'Smith Household'){
        		return new Account(Name = a.LastName + ' Household', RecordTypeId = HOUSEHOLD_RECORDTYPE);              
        }else{
        		return new Account(Name = a.LastName + ', ' + a.FirstName + ' Household', RecordTypeId = HOUSEHOLD_RECORDTYPE);         
        }
        
    }     
}