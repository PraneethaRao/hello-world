public class LeadCreateHousehold {
    static final Id PERSONACCT_RECORDTYPE = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    static final Id HOUSEHOLD_RECORDTYPE = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('IndustriesHousehold').getRecordTypeId();
    
    public static void create(List<Lead> leads){
        // ONLY SELECT LEADS THAT REQUIRE A HOUSEHOLD
        List<Lead> lds = new List<Lead>();
        for(Lead thisLead :leads){
            if(thisLead.Company == null && thisLead.Create_Household__c && thisLead.IsConverted){
                lds.add(thisLead);
            }
        }
        system.debug('LDS: ' + lds.size());  
        
        //CREATE ADDITIONAL PERSON ACCOUNTS
        Map<Id, Account> newaccts = new Map<Id, Account>();
        for(Integer i=0; i<lds.size(); i++){
            if(lds[i].Addtl_Contact_Last_Name__c != null){
                newaccts.put(lds[i].id, new Account(FirstName=lds[i].Addtl_Contact_First_Name__c, 
                                                    LastName = lds[i].Addtl_Contact_Last_Name__c, 
                                                    Phone = lds[i].Addtl_Contact_Phone__c,
                                                    PersonEmail = lds[i].Addtl_Contact_Email__c,
                                                    FinServ__Gender__pc = lds[i].Addtl_Contact_Gender__c,
                                                    PersonBirthdate = lds[i].Addtl_Contact_Birthdate__c,
                                                    FinServ__MaritalStatus__pc = lds[i].Addtl_Contact_Marital_Status__c,
                                                    PersonMailingStreet = lds[i].street,
                                                    PersonMailingCity = lds[i].city,
                                                    PersonMailingState = lds[i].state,
                                                    PersonMailingPostalCode = lds[i].postalcode,
                                                    Mailing_County__pc = lds[i].County__c,
                                                    RecordtypeId = PERSONACCT_RECORDTYPE));
            }
        }
        insert newaccts.values();
        // insert newaccts.values();
        system.debug('newaccts: ' + newaccts.values().size());
        
        List<Account> accounts = [SELECT Id, PersonContactId FROm Account WHERE Id In :newaccts.values()];
        for(Account a : accounts){            
            for(Id lid : newaccts.keyset()){
                if(newaccts.get(lid).Id == a.Id){
                    newaccts.put(lid,a);
                }
            }
        }
        
        //CREATE HOUSEHOLDS
        List<Account> hhNew = new List<Account>();
        for(Integer i=0; i < lds.size(); i++){
            hhNew.add(createHousehold(lds[i]));
        }
        insert hhNew;
        system.debug('HH: ' + hhNew.size());    
        
        // CREATE RELATIONSHIPS
        List<AccountContactRelation> acrList = new List<AccountContactRelation>();
        for(Integer i = 0; i < hhNew.size(); i++) {
            AccountContactRelation rel = new AccountContactRelation(
                                        AccountId = hhNew[i].Id, ContactId = lds[i].ConvertedContactId, FinServ__PrimaryGroup__c = true, 
                                        FinServ__Rollups__c='All', FinServ__Primary__c = true, Roles='Client');
        acrList.add(rel);
            
            if(newaccts.get(lds[i].Id) != null){
                AccountContactRelation rel2 = new AccountContactRelation(
                                        AccountId = hhNew[i].Id, ContactId = newaccts.get(lds[i].Id).PersonContactId, FinServ__PrimaryGroup__c = true, 
                                        FinServ__Rollups__c='All', Roles='Client');
                acrList.add(rel2);
            }    
        }
        insert acrList;
        system.debug('RELATIONSHIP LIST: ' + acrList.size());        
        
    }
    
    private static Account createHousehold(lead a){
        LeadCreateHouseholdConfig__mdt lch = New LeadCreateHouseholdConfig__mdt();
        lch = [SELECT id, MasterLabel, Household_Name_Format__c FROM LeadCreateHouseholdConfig__mdt LIMIT 1];

        if(lch.Household_Name_Format__c == 'John & Jane Smith Household'){
            if(a.Addtl_Contact_Last_Name__c == null){
                return new Account(Name = a.FirstName + ' ' + a.LastName + ' Household', RecordTypeId = HOUSEHOLD_RECORDTYPE);
            }Else{
                return new Account(Name = a.FirstName + ' & ' + a.Addtl_Contact_First_Name__c + ' ' + a.LastName + ' Household', RecordTypeId = HOUSEHOLD_RECORDTYPE);
            }    
        }else if(lch.Household_Name_Format__c == 'Smith Household'){
                return new Account(Name = a.LastName + ' Household', RecordTypeId = HOUSEHOLD_RECORDTYPE);              
        }else{
            if(a.Addtl_Contact_Last_Name__c == null){
                return new Account(Name = a.LastName + ', ' + a.FirstName + ' Household', RecordTypeId = HOUSEHOLD_RECORDTYPE);
            } else {
                return new Account(Name = a.LastName + ', ' + a.FirstName + ' & ' + a.Addtl_Contact_First_Name__c + ' Household', RecordTypeId = HOUSEHOLD_RECORDTYPE);
            }
        }
    }

}