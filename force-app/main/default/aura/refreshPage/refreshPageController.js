({
	doInit : function(component, event, helper) {
        
        window.setTimeout( $A.getCallback(function() { component.set("v.visible", true); }), 7000 );
     
       
          $A.get('e.force:refreshView').fire();
       
 
	},
    
    refresh : function(component, event, helper) {
      
  
     window.location.reload();
//$A.get('e.force:refreshView').fire();
       
     
       
		 
	},
    
    enrich :  function(component, event, helper) {
        
       // alert('In enrich');
    component.set("v.visible", false);
    	 	var recid = component.get("v.recordId");
       // alert(recid);
            var action = component.get("c.requestLeadHomeEnrichment");
        action.setParams({  leadId : recid});
            action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
               
           // var result = response.getReturnValue();
            if (state === "SUCCESS") {
            //alert('Enrichment request has been submitted.');
                component.set("v.visible", true);
               $A.get('e.force:refreshView').fire(); 
                
            } else if (state === "ERROR") {
                component.set("v.visible", true);
                var errors = response.getError();
                console.log(errors);
            }
        }));
        $A.enqueueAction(action);
    }
    
})