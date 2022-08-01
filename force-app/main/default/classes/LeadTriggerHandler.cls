public abstract class LeadTriggerHandler implements TriggerHandler{
    /*Members used by derived class */    
    protected List<Lead> oldLeads = Trigger.Old;
    protected List<Lead> newLeads = Trigger.New;
    protected Map<Id, Lead> oldLeadsMap = (Map<Id, Lead>)Trigger.oldMap;
    protected Map<Id, Lead> newLeadsMap = (Map<Id, Lead>)Trigger.newMap;
}