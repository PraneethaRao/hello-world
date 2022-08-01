({
	doInit : function(component, event, helper) {
		
	},
    
   /*  handleSubmit: function(component, event, helper) {
            event.preventDefault();       // stop the form from submitting
            var fields = event.getParam('fields');
             alert('in submit');
            component.find('ldform').submit(fields);
        },*/
    
    callSuccess : function(component, event, helper) {
            var params = event.getParams();
            alert(params.response.id);
        
        var recid = component.get("v.recordId");
       // alert(recid);
            var action = component.get("c.requestLeadAutoEnrichment");
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

    
        /*handleSuccess: function(component, event, helper) {
            alert('dsfdsf');

                var responseJSON = event.getParams();
    var recordId = responseJSON.id; 
        }*/

})