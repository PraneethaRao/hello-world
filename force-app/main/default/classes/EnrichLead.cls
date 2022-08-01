public without sharing class EnrichLead extends LeadTriggerHandler{
      public void execute(){  
       
          if (Trigger.isBefore && Trigger.isInsert ){
                   for (Lead newLead : newLeads) {
                   newLead.First_Owner_Name1__c='FromTrigger' ;
                   }
              
          }
          
      }

}