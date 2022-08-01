/*
*/
Public Interface TriggerHandler {
    
    /* This method should be implemented by the derived entity. It should have the logic for
     * all the trigger events for a specific object.  
	 */
    void execute();
}