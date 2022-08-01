/*	
    Interface : TriggerRunner
    Developer : Harsha simha Siddavatam
    Date      : 08/17/2017(mm/dd/yyyy)
    Comment   : This Class is responsible for running the trigger in the same order in which the 
				handlers was added.
    TestClass : Any test class on triggers that uses this handler will work.
*/
public class TriggerRunner {
    
    //Private Members
    List<Type> handlerTypeList = new List<Type>();
    List<sObject> oldObjs = new List<sObject>();
    List<sObject> newObjs = new List<sObject>();
    Map<id, sObject> oldObjsMap = new Map<id, sObject>();
    Map<id, sObject> newObjsMap = new Map<id, sObject>();

    /* This method will add the handler to this object. For example, pass Opportunity.Class
       in order to add the Opportunity handler
	 */
    public TriggerRunner addHandler(Type t){
        if(t==Null) return this;
        
        handlerTypeList.add(t);
        return this;
    }
    
    /* This method will run the handlers one by one in the same order it was added
	 */
    public void run(){
		for(Type t:handlerTypeList)
	        ((TriggerHandler)t.newInstance()).execute();
    }
}