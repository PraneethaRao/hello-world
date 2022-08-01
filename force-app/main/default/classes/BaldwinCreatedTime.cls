public class BaldwinCreatedTime {
    
    @InvocableMethod(label='Created Time' description='calculate Created Time' category='Time')
    public static List<String> requestQuote(List<flowInputvalues> inputs){
        
   		flowInputvalues leadInfo=inputs[0];
        Id leadId=leadInfo.LeadId;
        
        Lead ld=[Select Id,Name,Created_Time__c,CreatedDate,Created_Time2__c from Lead where Id=: leadId];
        
        

        system.debug('Created Date is ' + ld.CreatedDate);  
        system.debug('Created Date1 is ' + ld.CreatedDate.format('YYYY-MM-dd hh:mm:ss'));  

String s=ld.CreatedDate.format('YYYY-MM-dd hh:mm:ss');
String t=s.right(8);

system.debug('Time is' +t.left(2));
        
       
        
        List<string> ldList=new List<string>();
        ldList.add(t.left(2));
 		return ldList;
    
    }
        
         public class flowInputvalues{
        @invocablevariable
        public string LeadId;
  
    }
}