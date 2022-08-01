public class BaldwinEnrichmentController {
	
    @InvocableMethod(label='Request Enrichment')
    public static void invocableEnrichmentRequest(List<List<String>> propertyIds) {
        Id leadId=(Id) propertyIds[0][0];
        
        If(String.valueof(leadId.getSobjectType())=='Lead'){
            requestLeadHomeEnrichment(propertyIds[0][0]);
            
        }
        else{
            for(String str :propertyIds[0]) {
                requestEnrichment(str);
            }
        }
    }
    
   
    //added by Praneetha for SM -2 
   // @auraEnabled
  /*  public static boolean returnLead(String leadId){
                Lead ld = [SELECT Id, Is_Enriched__c
                                    FROM Lead 
                                    WHERE Id =: leadId];
        
        return ld.Is_Enriched__c;
    }*/
  
    //added by Praneetha for SM -2 
    @future(callout=true)    @auraEnabled
    public static void requestLeadHomeEnrichment(String leadId){
                Lead ld = [SELECT Id, Policy_Type__c,Year_Built__c,Roof_Type__c,Square_Footage__c,Dwelling_Type__c, Vehicle_Vin__c, Vehicle_Make__c, Vehicle_Model__c, 
                                    Vehicle_Year__c, Street,City,State,PostalCode,County__c,Is_enriched__c,Foundation_Type__c,Construction_Type__c,Roof_Design__c,
                           Heating_Type__c,Swimming_Pool_Type__c,No_of_stories__c,Full_Baths__c,Half_Baths__c
                                    FROM Lead 
                                    WHERE Id =: leadId];
               List<Property__c> existingHome=[Select Id from Property__c where Lead_and_Referral__c=:leadId];
                Id homerecordTypeId = Schema.SObjectType.Property__c.getRecordTypeInfosByName().get('Home').getRecordTypeId();
        Integration_Endpoint__mdt config = getIntegrationConfig('Home Enrichment');
        String endpoint = config.Endpoint__c;
        
        String requestBody = buildHomeLeadEnrichmentRequestBody(ld);
        System.debug('requestBody' + requestBody);
        
        HttpResponse response = makeAPICallout(endpoint, requestBody, 'POST', config);
        String responseBody = response.getBody();
        
        System.debug('response' + response);
        System.debug('response body = ' + responseBody);                
        if(response.getStatusCode() < 399){
            if(responseBody!=null){
            HomeEnrichmentResponse resultData = (HomeEnrichmentResponse) System.JSON.deserialize(responseBody, HomeEnrichmentResponse.class);
        
            ld.Year_Built__c = resultData.yearBuilt != null ? String.valueOf(resultData.yearBuilt) :null;
            ld.Dwelling_Type__c = resultData.dwelling != null ? resultData.dwelling : null;
            ld.Construction_Type__c = resultData.construction;
           	ld.Roof_Type__c = resultData.roof!=null ? resultData.roof :null;
            ld.Square_Footage__c = resultData.squareFootage != null ? resultData.squareFootage : null;
            ld.Foundation_Type__c = !String.isBlank(resultData.foundation) ? resultData.foundation : null;
            ld.Roof_Design__c = !String.isBlank(resultData.roofDesign) ? resultData.roofDesign :null;
            ld.No_of_stories__c = resultData.stories != null ? resultData.stories : null;
          ld.Full_Baths__c =resultData.fullBaths != null ? resultData.fullBaths : null;
           ld.Half_Baths__c =resultData.halfBaths != null ? resultData.fullBaths : null;
            ld.Structure_Type__c=resultData.structure!= null ? resultData.structure : null ;
            ld.Swimming_Pool_Type__c=resultData.swimmingPool!=null ? resultData.swimmingPool : null;
            ld.Heating_Type__c=resultData.heatingType!= null ? resultData.heatingType: null;
           /* if(fromComp){
            ld.Enrichment_Counter__c=ld.Enrichment_Counter__c!=null? ld.Enrichment_Counter__c+1:0+1;
            }*/
            ld.Is_enriched__c=true;
            
            System.debug('lead' + System.JSON.serialize(ld));
                Property__c home=new Property__c();
                home.RecordTypeId=homerecordTypeId;
                home.Year_Built__c=resultData.yearBuilt != null ? String.valueOf(resultData.yearBuilt) :null;
                home.Dwelling_Type__c=resultData.dwelling != null ? resultData.dwelling : null;
                home.Construction_Type__c = resultData.construction;
               home.Roof_Type__c = resultData.roof!=null ? resultData.roof :null;
            home.Square_Footage__c= resultData.squareFootage != null ? resultData.squareFootage : null;
          home.Foundation_Type__c = !String.isBlank(resultData.foundation) ? resultData.foundation : null;
            home.Roof_Design__c= !String.isBlank(resultData.roofDesign) ? resultData.roofDesign :null;
           home.No_of_stories__c = resultData.stories != null ? resultData.stories : null;
          home.No_of_FullBaths__c =resultData.fullBaths != null ? resultData.fullBaths : null;
           home.No_of_HalfBaths__c =resultData.halfBaths != null ? resultData.fullBaths : null;
            home.Structure_Type__c=resultData.structure!= null ? resultData.structure : null ;
            home.Swimming_Pool_Type__c=resultData.swimmingPool!=null ? resultData.swimmingPool : null;
            home.Heating_Type__c=resultData.heatingType!= null ? resultData.heatingType: null;
             home.Address_Line_1__c=ld.Street; 
             home.City__c=ld.City;
             home.State__c=ld.State;
             home.Zip_Code__c=ld.PostalCode;
                home.Lead_and_Referral__c=ld.id;
                 if(!existingHome.isEmpty()){
                     Delete existingHome[0];
                 }
                insert home;
                
            }
            else{
                
                 ld.Is_enriched__c=true; 
                
            }
           
            // String errormessage = '[ API Error : '+response.getStatusCode() + ' - ' + response.getStatus()+']' + response.getBody();
            // throw new AuraException(errormessage);
        }
                if(response.getStatusCode()!=200){
                    if(ld.Is_enriched__c==true){
                        ld.Is_enriched__c=false;
                    }
                    ld.Is_enriched__c=false;
                   ld.Year_Built__c = null;
            ld.Dwelling_Type__c =null;
            ld.Construction_Type__c = null;
           	ld.Roof_Type__c = null;
            ld.Square_Footage__c =null;
            ld.Foundation_Type__c =null;
            ld.Roof_Design__c =null;
            ld.No_of_stories__c =null;
            ld.Full_Baths__c =null;
           ld.Half_Baths__c =null;
            ld.Structure_Type__c=null;
            ld.Swimming_Pool_Type__c=null;
            ld.Heating_Type__c=null;
           /*                     if(fromComp){
            ld.Enrichment_Counter__c=ld.Enrichment_Counter__c+1;
            }*/
                    
                }
              update ld;
        }
        
            
    @auraEnabled
    public static String requestLeadAutoEnrichment(String leadId){
                Lead ld = [SELECT Id, Policy_Type__c,Year_Built__c,Roof_Type__c,Square_Footage__c,Dwelling_Type__c, Vehicle_Vin__c, Vehicle_Make__c, Vehicle_Model__c, 
                                    Vehicle_Year__c, Street,City,State,PostalCode,County__c,Is_enriched__c,Foundation_Type__c,Construction_Type__c,Roof_Design__c,
                           			Heating_Type__c,Swimming_Pool_Type__c,No_of_stories__c,Full_Baths__c,Half_Baths__c
                                    FROM Lead 
                                    WHERE Id =: leadId];
 
                
       Integration_Endpoint__mdt config = getIntegrationConfig('Auto Enrichment');
            String endpoint = config.Endpoint__c + ld.Vehicle_Vin__c;
            HttpResponse response = makeAPICallout(endpoint, null, 'GET', config);
            String responseBody = response.getBody();
            System.debug('response body = ' + responseBody);

            if(response.getStatusCode() < 399){
                AutoEnrichmentResponse resultData = (AutoEnrichmentResponse) System.JSON.deserialize(responseBody, AutoEnrichmentResponse.class);
            
                System.debug('-- result: ' + resultData);

                ld.Vehicle_Make__c = resultData.make;
                ld.Vehicle_Model__c = resultData.model;
                ld.Vehicle_Year__c = String.valueOf(resultData.year);
                
                update ld;
                Property__c pr= new Property__c();
                pr.Lead_and_Referral__c=ld.Id;
                pr.Vehicle_Year__c=String.valueOf(resultData.year);
                pr.Vehicle_Make__c=resultData.make;
                pr.Vehicle_Model__c=resultData.model;
                pr.VIN__c=ld.Vehicle_Vin__c;
                
                insert pr;
                // String errormessage = '[ API Error : '+response.getStatusCode() + ' - ' + response.getStatus()+']' + response.getBody();
                // throw new AuraException(errormessage);
            }
            
        else{
            throw new AuraException('VIN not present on vehicle record!');
        }
        return 'Success';
        
        
    }
            
            
 
    
    
    
    

    @auraEnabled
    public static String requestEnrichment(String propertyId){
        try{
            Property__c property = [SELECT Id, Recordtype.Name, VIN__c, Vehicle_Make__c, Vehicle_Model__c, 
                                    Vehicle_Year__c, Address_Line_1__c, Address_Line_2__c, City__c, 
                                    State__c, Zip_Code__c, Roof_Material__c, No_of_stories__c,No_of_FullBaths__c,
                                    Year_Built__c, Dwelling_Type__c, Type_of_Construction__c, Construction_Type__c,
                                    Square_Footage__c, Substructure__c, Roof_Design__c,County__c,Foundation_Type__c,
                                    Swimming_Pool_Type__c,No_of_HalfBaths__c,Heating_Type__c,Structure_Type__c
                                    FROM Property__c 
                                    WHERE Id =: propertyId];
            
            if(property.RecordType.Name == 'Auto'){
                return requestAutoEnrichment(property);
            }
            if(property.RecordType.Name == 'Home'){
                return requestHomeEnrichment(property);
            }
            return null;
        } catch(exception exec){
            System.debug('-- errors: ' + exec.getMessage());
            throw new AuraException(exec.getMessage());
        }
    }
       
    public static String requestAutoEnrichment(Property__c property){

        if(property.VIN__c != null){
            Integration_Endpoint__mdt config = getIntegrationConfig('Auto Enrichment');
            String endpoint = config.Endpoint__c + property.VIN__c;
            HttpResponse response = makeAPICallout(endpoint, null, 'GET', config);
            String responseBody = response.getBody();
            System.debug('response body = ' + responseBody);

            if(response.getStatusCode() < 399){
                AutoEnrichmentResponse resultData = (AutoEnrichmentResponse) System.JSON.deserialize(responseBody, AutoEnrichmentResponse.class);
            
                System.debug('-- result: ' + resultData);

                property.Vehicle_Make__c = resultData.make;
                property.Vehicle_Model__c = resultData.model;
                property.Vehicle_Year__c = String.valueOf(resultData.year);
                
                update property;
                // String errormessage = '[ API Error : '+response.getStatusCode() + ' - ' + response.getStatus()+']' + response.getBody();
                // throw new AuraException(errormessage);
            }
            
        }else{
            throw new AuraException('VIN not present on vehicle record!');
        }
        return 'Success';
    }
        
    public static string requestHomeEnrichment(Property__c property){
                
        Integration_Endpoint__mdt config = getIntegrationConfig('Home Enrichment');
        String endpoint = config.Endpoint__c;
        
        String requestBody = buildHomeEnrichmentRequestBody(property);
        System.debug('requestBody' + requestBody);
        
        HttpResponse response = makeAPICallout(endpoint, requestBody, 'POST', config);
        String responseBody = response.getBody();
        
        System.debug('response' + response);
        System.debug('response body = ' + responseBody);                
        if(response.getStatusCode() < 399){
            HomeEnrichmentResponse resultData = (HomeEnrichmentResponse) System.JSON.deserialize(responseBody, HomeEnrichmentResponse.class);
        
            property.Year_Built__c = resultData.yearBuilt != null ? String.valueOf(resultData.yearBuilt) : property.Year_Built__c;
            property.Dwelling_Type__c = resultData.dwelling != null ? resultData.dwelling : property.Dwelling_Type__c;
            property.Construction_Type__c = resultData.construction!= null ? resultData.construction :   property.Construction_Type__c ;
            property.Roof_Material__c = !String.isBlank(resultData.roof) ? resultData.roof : property.Roof_Material__c;
            property.Square_Footage__c = resultData.squareFootage != null ? resultData.squareFootage : property.Square_Footage__c;
            property.Foundation_Type__c = !String.isBlank(resultData.foundation) ? resultData.foundation : property.Foundation_Type__c;
            property.Roof_Design__c = !String.isBlank(resultData.roofDesign) ? resultData.roofDesign : property.Roof_Design__c;
            property.No_of_stories__c = resultData.stories != null ? resultData.stories : property.No_of_stories__c;  
            property.No_of_FullBaths__c =resultData.fullBaths != null ? resultData.fullBaths : property.No_of_FullBaths__c;
            Property.Structure_Type__c=resultData.structure !=null ? resultData.structure : property.Structure_Type__c;
            Property.Swimming_Pool_Type__c=resultData.swimmingPool!=null ? resultData.swimmingPool : Property.Swimming_Pool_Type__c ;
            Property.Heating_Type__c=resultData.heatingType!= null ? resultData.heatingType : property.Heating_Type__c ;
            Property.No_of_HalfBaths__c=resultData.halfBaths!= null ? resultData.halfBaths : property.No_of_HalfBaths__c;    	
            
            System.debug('property' + System.JSON.serialize(property));
            
            update property;
            // String errormessage = '[ API Error : '+response.getStatusCode() + ' - ' + response.getStatus()+']' + response.getBody();
            // throw new AuraException(errormessage);
        }
        return 'Success';
    }
    
    private static string buildHomeEnrichmentRequestBody(Property__c property){
        HomeEnrichmentRequest requestWrapp = new HomeEnrichmentRequest();
        requestWrapp.type = 'Other';
        requestWrapp.street = property.Address_Line_1__c;
        requestWrapp.street2 = property.Address_Line_2__c;
        requestWrapp.city = property.City__c;
        requestWrapp.state = property.State__c;
        requestWrapp.zip = property.Zip_Code__c;
        requestWrapp.county=property.County__c;
        
        return System.JSON.serialize(requestWrapp, true);
    }
    
        
    private static string buildHomeLeadEnrichmentRequestBody(Lead ld){
        HomeEnrichmentRequest requestWrapp = new HomeEnrichmentRequest();
        requestWrapp.type = 'Other';
        requestWrapp.street = ld.Street;
        //requestWrapp.street2 = property.Address_Line_2__c;
        requestWrapp.city = ld.City;
        requestWrapp.state = ld.State;
        requestWrapp.zip = ld.PostalCode;
        //requestWrapp.county=property.County__c;
        
        return System.JSON.serialize(requestWrapp, true);
    }
    

    private static HttpResponse makeAPICallout(String endpoint, String body, String method, Integration_Endpoint__mdt config){
        HttpRequest req = new HttpRequest();
        
        req.setEndPoint(endpoint);
        req.setHeader('Accept','application/json, text/plain');
        req.setHeader('client_id',config.Integration_Auth__r.Client_Id__c);
        req.setHeader('client_secret',config.Integration_Auth__r.Client_Secret__c );
        
        req.setMethod(method);
        if(body != null) {
            req.setHeader('Content-Type','application/json;charset=utf-8');
            req.setBody(body);
        }
        req.setTimeout(120000);
        
        Http httpObj = new Http();
        //Httpresponse res=new Httpresponse();
      //  res.setBody('{}');
        HttpResponse res = httpObj.send(req);        
        return res;
    }
    
    private static Integration_Endpoint__mdt getIntegrationConfig(String name) {
        return [SELECT MasterLabel,
                Endpoint__c,
                Integration_Auth__r.Client_Id__c,
                Integration_Auth__r.Client_Secret__c
                FROM Integration_Endpoint__mdt
                WHERE MasterLabel =: name];
        
    }
    
    public class AutoEnrichmentResponse{
        public String vin;	//1ASDF234
        public String make;	//Chevrolet
        public String model;	//Camaro
        public Integer year;	//2020
        public boolean antiLockBrakes;
        public String security;	//Anti-theft device
        public boolean drl;
        public String restraint;	//AirbagBothSides
        public Integer basePrice;	//25000
        public String fuel;	//Gas        
    }
    
    public class HomeEnrichmentRequest{
        public String type;	//Mailing
        public String street;	//123 Test Street
        public String street2;	//Ste 123
        public String city;	//Tampa
        public String state;	//FL
        public String zip;	//12345-1234
        public String county;
    }
    
    public class HomeEnrichmentResponse{
        public Integer yearBuilt;	//2015
        public String dwelling;	//One Family
        public String stories;	//2
        public String fullBaths;	//2
        public String construction;	//Stucco on Block
        public String structure;	//Bi-Level
        public String roof;	//ASPHALT SHINGLES
        public String heatingType;	//Forced Air
        public Integer squareFootage;	//2203
        public String foundation;	//Concrete Slab
        public String roofDesign;	//Gable
        //Added as part of SM-2
        public String halfBaths;	//2
        public String swimmingPool;
   
    }
}