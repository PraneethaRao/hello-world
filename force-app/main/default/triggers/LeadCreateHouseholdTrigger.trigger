trigger LeadCreateHouseholdTrigger on Lead (after update) {
	LeadCreateHousehold.create(Trigger.New);
    
       //EnrichLead.execute();
    
 //new TriggerRunner(addHandler(EnrichLead.class)).run();
    
    /*TriggerRunner add=new TriggerRunner();
    
   add.addHandler(EnrichLead.class)
       
       .run();  */  
}