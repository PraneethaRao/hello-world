@IsTest
public class LeadCreateHouseholdTest {
    static final Id PERSONACCT_RECORDTYPE = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();

    @isTest
    static void testCreate() {
        System.runAs(getRunAsProfile()) {
            Lead l = new Lead(FirstName = 'First', LastName = 'Testing', Phone='123456789', Create_Household__c=true, Addtl_Contact_First_Name__c='Test', Addtl_Contact_Last_Name__c='Test');
            insert l;

            Database.LeadConvert lc = new database.LeadConvert();
            lc.setLeadId(l.Id);
            
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            lc.setConvertedStatus(convertStatus.MasterLabel);

            Database.LeadConvertResult lcr = Database.convertLead(lc);
            System.assert(lcr.isSuccess());

            List<AccountContactRelation> rels = new List<AccountContactRelation>([SELECT Id FROM AccountContactRelation]);
            system.assertEquals(true, rels.size() > 0);        
        }
    }
    
    @isTest
    static void testCreate1() {
        System.runAs(getRunAsProfile()) {

            Lead l = new Lead(FirstName = 'First', LastName = 'Testing', Phone='123456789', Create_Household__c=true);
            insert l;

            Database.LeadConvert lc = new database.LeadConvert();
            lc.setLeadId(l.Id);
            
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            lc.setConvertedStatus(convertStatus.MasterLabel);

            Database.LeadConvertResult lcr = Database.convertLead(lc);
            System.assert(lcr.isSuccess());

            List<AccountContactRelation> rels = new List<AccountContactRelation>([SELECT Id FROM AccountContactRelation]);
            system.assertEquals(true, rels.size() > 0);
        }
    }

    
    @isTest
    static void testCreate2() {
        System.runAs(getRunAsProfile()) {
            Lead l = new Lead(FirstName = 'First', LastName = 'Testing', Phone='123456789', Create_Household__c=false);
            insert l;

            Database.LeadConvert lc = new database.LeadConvert();
            lc.setLeadId(l.Id);
            
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            lc.setConvertedStatus(convertStatus.MasterLabel);

            Database.LeadConvertResult lcr = Database.convertLead(lc);
            System.assert(lcr.isSuccess());

            List<AccountContactRelation> rels = new List<AccountContactRelation>([SELECT Id FROM AccountContactRelation]);
            // system.assertEquals(true, rels.size() > 0);
        }
    }

    private static User getRunAsProfile() {
        return [SELECT Id, Name FROM User WHERE Profile.Name like 'Mainstreet Velocify%' and IsActive = true LIMIT 1];
    }
}