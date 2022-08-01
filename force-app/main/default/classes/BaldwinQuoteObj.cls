public with sharing class BaldwinQuoteObj {
    
    public class HomeQuote {

        public String opportunityId = null;    //0063j000012CW8qAAG
        public String brpGroup = null;
        public List<cls_applicant> applicants = new List<cls_applicant>();
        public cls_dwelling dwelling = new cls_dwelling();
        public cls_policyInfo policyInfo = new cls_policyInfo();

    }

    public class AutoQuote {

        public String opportunityId;    //0063j000012CW8qAAG
        public String brpGroup;
        public cls_generalCoverages generalCoverages = new cls_generalCoverages();
        public List<cls_driver> drivers = new List<cls_driver>();
        public List<cls_vehicle> vehicles = new List<cls_vehicle>();
        public cls_priorPolicy priorPolicy = new cls_priorPolicy();

    }

    public class BundledQuote {

        public String opportunityId = null;    //0063j000012CW8qAAG
        public String brpGroup = null;
        public cls_generalCoverages generalCoverages = new cls_generalCoverages();
        public cls_priorPolicy priorPolicy;
        public List<cls_driver> drivers = new List<cls_driver>();
        public List<cls_vehicle> vehicles = new List<cls_vehicle>();
        public cls_dwelling dwelling = new cls_dwelling();
        public cls_policyInfo homePolicyInfo = new cls_policyInfo();

    }

    public class cls_applicant {
        public List<cls_address> address = new List<cls_address>();
        public String suffix = null;    //III
        public String education = null;    //Masters
        public String birthDate = null;    //2020-01-01
        public String relation = null;    //Insured
        public String email = null;    //nalessan_brp2+1@baldwinrp.co
        public String salutation = null;    //Mr.
        public String first = null;    //FirstName
        public String sex = null;    //Male
        public List<cls_phone> phone = new List<cls_phone>();
        public String maidenName = null;    //Jones
        public String industry = null;    //Medical
        public String type = null;    //Applicant
        public String occupation = null;    //Dentist
        public String maritalStatus = null;    //Married
        public String last = null;    //Lastname
        public String middle = null;    //Middle
    }

    public class cls_address {
        public String type = 'Mailing';    //Mailing
        public String street = null;    //123 Test Street
        public String street2 = '';    //Ste 123
        public String city = null;    //Tampa
        public String state = null;    //FL
        public String zip = null;    //12345-1234
        public String county = null;
    }

    public class cls_phone {
        public String type = 'Home';    //Home
        public String phone = null;    //555-555-5555
        public Integer ext = null;    //1234
    }

    public class cls_policyInfo {
        public cls_priorPolicy priorPolicy = new cls_priorPolicy();
        public String effectiveDate = null;    //2020-01-01
        public cls_replacementCosts replacementCosts = new cls_replacementCosts();
        // public cls_credits credits = new cls_credits();
    }

    public class cls_priorPolicy {
        public String carrier = null;    //Geico
        public String expiration = null;    //2020-01-01
    }

    public class cls_replacementCosts {
        public decimal replacementCost = 0;    //500000
        public decimal dwelling = 0;    //100000
        public String personalLiability = null;    //100000
        public String medicalPayments = null;    //1000
        public String deductible = null;    //500
    }

    public class cls_dwelling {
        public cls_address address = new cls_address();
        public String type = null;    //One Family
        public String use = 'Primary';    //Primary
        public Integer yearBuilt = 0;    //1995
        public decimal squareFootage = 0;    //2050
        public String occupants = null;    //10
        public Date purchaseDate = null;    //2020-01-01
        public decimal purchasePrice = 0;    //250000
        public boolean withinCityLimits = false;
        public boolean withinProtectedSuburb = false;
        public String construction = null;    //
        public String structure = null;    //
        public String roof = null;    //
        public String roofShape = null;    //
        public String roofDesign = null;    //
        public String foundation = null;    //
        public boolean swimmingPool = false;
        public String swimmingPoolType = null;    //
        public boolean dogOnPremise = false;
        public Decimal replacementCosts = 0;
        public String allOtherPerilsdeductible=null;
        public String hurricaneDeductible=null;
        public String personalLiability=null;
        public string medicalPayments=null;
        public string personalPropertyReplacementCost='Yes';
        //public Decimal exteriorWalls;
        public string heatingType;
        public string stories;
        public string halfBaths;
        public string fullBaths;
        public Integer roofUpdateYear;
        public Integer electricalUpdateYear;
        public Integer plumbingUpdateYear;
        public Integer heatingUpdateYear;
        public string dogBreedType;
        public boolean underConstruction = false;
        
           
        // public List<cls_miscRatingInfo> miscRatingInfo = new List<cls_miscRatingInfo>();
    }

    public class cls_generalCoverages {
        public String bodilyInjury = null;    //State Minimum
        public String propertyDamage = null;    //State Minimum
        public String mp = null;    //None
        public String unisuredMotorist = null;    //Reject
        public String uim = null;    //Reject
    }

    public class cls_driver {
        public Integer id;
        public List<cls_vehicleCompLoss> vehicleCompLoss = new List<cls_vehicleCompLoss>();
        public boolean licenseRevokedSuspended = false;
        public String dlState = null;    //A425-34-123-4567-0
        public String dateLicenced = null;    //2020-01-01
        public List<cls_address>  address = new List<cls_address>();
        public String suffix = null;    //III
        public String birthDate = null;    //2020-01-01
        public String education = null;    //Masters
        public String dlStatus = 'Valid';    //Valid
        public String relation = null;    //Insured
        public String email = null;    //nalessan_brp2+1@baldwinrp.co
        public String salutation = null;    //Mr.
        public List<cls_phone> phone = new List<cls_phone>();
        public String first = null;    //FirstName
        public String sex = null;    //Male
        public String maidenName = null;    //Jones
        public String industry = null;    //Medical
        public String dlNumber = null;    //A425-34-123-4567-0
        public String type = null;    //Applicant
        public List<cls_accident> accidents = new List<cls_accident>();
        public String occupation = null;    //Dentist
        public String maritalStatus = null;    //Married
        public String last = null;    //Lastname
        public List<cls_violation> violations = new List<cls_violation>();
        public String middle = null;    //Middle
        public Integer ssn = null;    //123456789
    }

    public class cls_vehicleCompLoss {
        public String date1 = null;    //2020-10-01
        public String description = null;    //Fire
        public decimal value = 0;    //50
        public Integer vehicleInvolved = 0;    //1
    }

    public class cls_accident {
        public Integer id = 1;    //1
        public String date1 = null;    //2020-01-01
        public String description = null;    //Not At Fault
        public Integer propertyDamage = 0;    //500
        public Integer bodilyInjury = 0;    //10000
        public Integer collision = 0;    //750
        public Integer vehicleInvolved = 0;    //1
    }

    public class cls_violation {
        public String date1 = null;    //2020-10-01
        public String description = null;    //Careless Driving
    }

    public class cls_vehicle {
        public Integer id = 1;    //1
        public boolean useVinLookup = true;
        public String vin = null;    //asdfxxxx
        public String make = null;    //Toyota
        public String model = null;    //4Runner
        public String subModel = null;    
        public String vehicleInspection = 'No Inspection Needed';    //Bill of Sale For New Vehicle
        public String vehiclePurchaseDate = null;    //2020-01-01
        public String useage = 'Pleasure';    //Business
        public decimal oneWayMiles = 0;    //30
        public Integer daysPerWeek = 5;    //7
        public Integer weeksPerMonth = 4;    //4
        public decimal annualMiles = 0;    //15000
        public String ownership = null;    //Owned
        public decimal principalOperator = 0;    //1
        public String collisionDeductible = 'No Coverage';    //No Coverage
        public String additionalCollision = 'No Coverage';    //No Coverage
        public String towing = 'No Coverage'; //No Coverage
        public String rental = 'No Coverage';    //15
        public String bodilyInjuryLiability= null;
        public String propertyDamage = null;
        public String uninsuredMotoristLiability=null;
        public String medicalPayments = null;
        public String compDeductible=null;
        public String collisionDeductibleCost=null;
        public string towingLabor=null;
        public string rentalReimbursement=null;
       
           
    }

    public static cls_dwelling getDwellingFromList(List<Property__c> propertyList) {
        for(Property__c prop :propertyList) {
            if(prop.RecordType.Name == 'Home')
                return getDwelling(prop);
        }

        return null;
    }

    public static cls_dwelling getDwelling(Property__c property) {
        cls_dwelling dwelling = new cls_dwelling();
        //dwelling.id = property.Id;
        dwelling.type = getValue(property.Dwelling_Type__c);
        if(String.isNotBlank(property.Dwelling_Usage__c)) dwelling.use = property.Dwelling_Usage__c;
        dwelling.yearBuilt = String.isNotBlank(property.Year_Built__c) ? Integer.valueOf(property.Year_Built__c) : null;
        dwelling.squareFootage = getValue(property.Square_Footage__c);
        dwelling.occupants = property.Number_of_Occupants__c;
        dwelling.purchaseDate = property?.Purchase_Date__c;
        dwelling.purchasePrice = getValue(property.Purchase_Price__c);
        dwelling.construction = getValue(property.Construction_Type__c);
        dwelling.structure = getValue(property.Structure_Type__c);        
        dwelling.roof = getValue(property.Roof_Type__c);
        dwelling.roofDesign = getValue(property.RoofDesign__c);
        dwelling.foundation = getValue(property.Foundation_Type__c);
        dwelling.replacementCosts = getValue(property.Replacement_Cost__c);
        dwelling.address = getAddress((sObject)property) ;
        dwelling.allOtherPerilsdeductible=getValue(property.All_Other_Perils_Deductible__c);
        dwelling.hurricaneDeductible=getValue(property.Hurricane_Deductible__c);
        dwelling.personalLiability=getValue(property.Personal_Liability__c);
        dwelling.medicalPayments=getValue(property.Medical_Payments__c);
        dwelling.personalPropertyReplacementCost=getValue(property.Personal_Property_Replacement_Cost__c);
     //   dwelling.exteriorWalls=getValue(property.Exterior_Walls__c);
        dwelling.heatingType=getValue(property.Heating_Type__c);
        dwelling.stories=getValue(property.No_of_stories__c);
       dwelling.halfBaths=getValue(property.No_of_HalfBaths__c);
        dwelling.fullBaths=getValue(property.No_of_FullBaths__c);
        dwelling.swimmingPoolType=getValue(property.Swimming_Pool_Type__c);
        dwelling.swimmingPool=property.Swimming_Pool_Type__c != null ? true:false;
        dwelling.roofUpdateYear = String.isNotBlank(property.Year_Roof_Installed__c) ? Integer.valueOf(property.Year_Roof_Installed__c) : null;
        dwelling.electricalUpdateYear = String.isNotBlank(property.Year_Electrical_Update__c) ? Integer.valueOf(property.Year_Electrical_Update__c) : null;
        dwelling.plumbingUpdateYear = String.isNotBlank(property.Year_Plumbing_Update__c) ? Integer.valueOf(property.Year_Plumbing_Update__c) : null;
        dwelling.heatingUpdateYear = String.isNotBlank(property.Year_Heating_Update__c) ? Integer.valueOf(property.Year_Heating_Update__c) : null;
        dwelling.underConstruction= property.Dwelling_Under_Construction__c;
        dwelling.dogOnPremise=property.Dog_Breed_Type__c != null ? true:false;
        dwelling.dogBreedType=getValue(property.Dog_Breed_Type__c);
        
    /*public Integer roofUpdateYear;
        public Integer electricalUpdateYear;
        public Integer plumbingUpdateYear;
        public Integer heatingUpdateYear;
        public string dogBreedType;
        public boolean underConstruction = false;
           public boolean dogOnPremise = false;*/
        
        return dwelling;
    }

    public static cls_address getAddress(sObject obj) {
        cls_address addy = new cls_address();
        System.debug('--- objType: ' + obj.getSobjectType().getDescribe().getName());
        if(obj.getSobjectType().getDescribe().getName() == 'Account') {
            addy.street = (String)obj.get('PersonMailingStreet');
            addy.city = (String)obj.get('PersonMailingCity');
            addy.state = (String)obj.get('PersonMailingState');
            addy.zip = (String)obj.get('PersonMailingPostalCode');
            addy.county = (String)obj.get('Mailing_County__pc');
        }
        else if (obj.getSobjectType().getDescribe().getName() == 'Contact') {
            System.debug('--- contact record: ' + obj);
            addy.street = (String)obj.get('MailingStreet');
            addy.state = (String)obj.get('MailingState');
            addy.city = (String)obj.get('MailingCity');
            addy.county = (String)obj.get('Mailing_County__c');
            addy.zip = (String)obj.get('MailingPostalCode');
        }
        else {
            addy.street = (String)obj.get('Address_Line_1__c');
            addy.city = (String)obj.get('City__c');
            addy.state = (String)obj.get('State__c');
            addy.zip = (String)obj.get('Zip_Code__c');
            addy.county = (String)obj.get('County__c');
        }

        if(String.isNotBlank(addy.street))
            return addy;

        return null;
    }

    public static cls_phone getPhone(sObject obj) {
        cls_phone phone = new cls_phone();
        phone.phone = (String)obj.get('Phone');

        return phone;
    }

    public static cls_policyInfo getPolicyInfo(Property__c property) {
        cls_policyInfo policyInfo = new cls_policyInfo(); 
        policyInfo.priorPolicy = getPriorPolicy(property);

        policyInfo.replacementCosts = new BaldwinQuoteObj.cls_replacementCosts();
        policyInfo.replacementCosts.replacementCost = getValue(property.Replacement_Cost__c);
        policyInfo.replacementCosts.dwelling = property.Replacement_Cost__c != null ? (property.Replacement_Cost__c * 0.80) : 0;

        return policyInfo;
    }

    public static List<cls_applicant> getApplicants(List<Account> listAccounts, Id OppAcctId) {
        
        List<cls_applicant> applicants = new List<cls_applicant>();
        for(Account account : listAccounts){
            cls_applicant applicant = new cls_applicant();
            applicant.type = account.id == OppAcctId ? 'Applicant' : 'CoApplicant';
            applicant.salutation = getValue(account.Salutation);
            applicant.first = getValue(account.Firstname);
            applicant.last = getValue(account.Lastname);
            applicant.middle = getValue(account.MiddleName);
            applicant.suffix = getValue(account.suffix);
            applicant.birthDate = account.PersonBirthdate != null ?  String.valueOf(account.PersonBirthdate): '';
            applicant.email = getValue(account.PersonEmail);
            applicant.sex = getValue(account.FinServ__Gender__pc);
            applicant.industry = account?.Industry;
            applicant.occupation = account?.Occupation__c;
            
            if(String.isNotBlank(account.PersonMailingStreet))
                applicant.address.add(getAddress((sObject)account));

            applicant.phone.add(getPhone(account));
            applicant.maritalStatus = getValue(account.FinServ__MaritalStatus__pc);
   
            applicants.add(applicant);
        }
        return applicants;
    }

    public static cls_generalCoverages getGeneralCoverages(Property__c property) {
        cls_generalCoverages genCover = new cls_generalCoverages();
        genCover.bodilyInjury = String.isNotBlank(property.BI_Coverage_Needed__c ) ? getValue(property.BI_Coverage_Needed__c) : null;
        genCover.unisuredMotorist = String.isNotBlank(property.Uninsured_Motorist__c) ? getValue(property.Uninsured_Motorist__c) : null;

        return genCover;
    }

    public static List<cls_vehicle> getVehicles(List<Property__c> listProperties, List<Driver__c> drivers) {
        List<cls_vehicle> vehicles = new List<cls_vehicle>();
        boolean skipped = false;
        for(Integer i=0; i<listProperties.size(); i++){
            if(listProperties[i].RecordType.Name == 'Auto') {
                cls_vehicle vehicle = new cls_vehicle();
                vehicle.id = skipped ? i : i + 1;
                if(String.isNotBlank(listProperties[i].Vehicle_Use__c))
                    vehicle.useage = listProperties[i].Vehicle_Use__c;
                // vehicle.useVinLookup = listProperties[i].UseVin_Lookup__c;
                vehicle.vin = getValue(listProperties[i].VIN__c);
                vehicle.make = getValue(listProperties[i].Vehicle_Make__c);
                vehicle.model = getValue(listProperties[i].Vehicle_Model__c);
                vehicle.subModel = getValue(listProperties[i].Vehicle_Sub_Model__c);
                vehicle.vehiclePurchaseDate = listProperties[i].Purchase_Date__c != null ?  String.valueOf(listProperties[i].Purchase_Date__c): String.valueOf(Date.today());
                vehicle.oneWayMiles = getValue(listProperties[i].One_Way_Miles__c);
                vehicle.annualMiles = getValue(listProperties[i].Annual_Miles__c);
                vehicle.ownership = getValue(listProperties[i].Own_or_Rent_Vehicle__c);
                vehicle.principalOperator = getPrincipalOperator(listProperties[i].Assigned_Drivers__r, drivers);
                vehicle.collisionDeductible = listProperties[i].Collision_Deductible__c!= null ?  String.valueOf(listProperties[i].Collision_Deductible__c): 'No Coverage';
                vehicle.rental = listProperties[i].Rental_Cost__c != null ?  String.valueOf(listProperties[i].Rental_Cost__c): 'No Coverage';
                vehicle.bodilyInjuryLiability=getValue(listProperties[i].Bodily_Injury_Liability__c);
                vehicle.propertyDamage=getValue(listProperties[i].Property_Damage__c);
                vehicle.uninsuredMotoristLiability=getValue(listProperties[i].Uninsured_Motorist_Liability__c);
                vehicle.medicalPayments=getValue(listProperties[i].Medical_Payments__c);
                vehicle.compDeductible=getValue(listProperties[i].Comp_Deductible__c);
                  vehicle.collisionDeductibleCost=getValue(listProperties[i].Collision_Deductible_PL__c);
                  vehicle.towingLabor=getValue(listProperties[i].Towing_Labor__c);
                  vehicle.rentalReimbursement=getValue(listProperties[i].Rental_Reimbursement_Ext_Trans_Expense__c);
                

                vehicles.add(vehicle);
            }
            else {
                skipped = true;
            }
        }
        return vehicles;
    }

    public static List<cls_driver> getDrivers(List<Driver__c> lstDrivers, Id accPersonContactId) {
        List<cls_driver> drivers = new List<cls_driver>();
        for(Integer i=0; i<lstDrivers.size(); i++){
            cls_driver driverWrap = new cls_driver();
            driverWrap.id = i + 1;
            driverWrap.dlState = lstDrivers[i]?.License_State__c;
            driverWrap.birthDate = String.valueOf(lstDrivers[i].Driver_Contact__r.Birthdate);
            driverWrap.dlStatus = String.isNotBlank(lstDrivers[i].Driver_License_Status__c) ? getValue(lstDrivers[i].Driver_License_Status__c) : 'Valid';
            driverWrap.first = getValue(lstDrivers[i].Driver_Contact__r?.firstname);
            driverWrap.last = getValue(lstDrivers[i].Driver_Contact__r?.lastname);
            driverWrap.dlNumber = lstDrivers[i]?.License_Number__c;
            driverWrap.type = (accPersonContactId == lstDrivers[i].Driver_Contact__c) ? 'Applicant' : 'CoApplicant' ;
            // driverWrap.occupation = getValue(lstDrivers[i].Occupation__c);
            driverWrap.maritalStatus = getValue(lstDrivers[i].Marital_Status__c);
            driverWrap.ssn = String.isNotBlank(lstDrivers[i].Driver_Contact__r.SSN__c) ? Integer.valueOf(lstDrivers[i].Driver_Contact__r.SSN__c) : null;
            driverWrap.suffix = lstDrivers[i].Driver_Contact__r?.Suffix;
            driverWrap.email = getValue(lstDrivers[i].Driver_Contact__r?.Email);
            driverWrap.sex = getValue(lstDrivers[i].Driver_Contact__r?.FinServ__Gender__c);
            driverWrap.dateLicenced = String.valueOf(lstDrivers[i].License_Date__c);
            driverWrap.phone.add(getPhone(lstDrivers[i].Driver_Contact__r));
            driverWrap.industry = lstDrivers[i].Driver_Contact__r.Account?.Industry;
            driverWrap.occupation = lstDrivers[i].Driver_Contact__r.Account?.Occupation__c;

            if(lstDrivers[i].CompLoss_Date__c != null)
                driverWrap.vehicleCompLoss.add(getVehicleCompLoss(lstDrivers[i]));
            
            if(lstDrivers[i].Incident_Date_1__c  != null)
                driverWrap.accidents.add(getAccidents(lstDrivers[i]));

            if(!String.isBlank(lstDrivers[i].Driver_Contact__r.MailingStreet))
                driverWrap.address.add(getAddress((sObject)lstDrivers[i].Driver_Contact__r));

            if(lstDrivers[i].Violation_Date__c  != null)
                driverWrap.violations.add(getViolations(lstDrivers[i]));

            drivers.add(driverWrap);
        }

        return drivers;
    }

    public static cls_vehicleCompLoss getVehicleCompLoss(Driver__c driver) {
        if(driver.CompLoss_Date__c == null)
            return null;
        
        cls_vehicleCompLoss vComploss = new cls_vehicleCompLoss();
        vComploss.date1 = driver.CompLoss_Date__c != null ? String.valueOf(driver.CompLoss_Date__c) : null;
        vComploss.description = getValue(driver.CompLoss_Description__c);
        vComploss.value = getValue(driver.CompLoss_Value__c);

        return vComploss;
    }

    public static cls_accident getAccidents(Driver__c driver) {
        if(driver.Incident_Date_1__c  == null)
            return null;
        
        cls_accident accident = new cls_accident();
        accident.date1 = driver.Incident_Date_1__c != null ? String.valueOf(driver.Incident_Date_1__c) : null;
        accident.description = getValue(driver.Incident_1_Description__c);

        return accident;
    }

    public static cls_violation getViolations(Driver__c driver) {
        if(driver.Incident_Date_1__c  == null)
            return null;
        
        cls_violation violation = new cls_violation();
        violation.description = getValue(driver.Violation_Description__c);
        violation.date1 = driver.Violation_Date__c != null ? String.valueOf(driver.Violation_Date__c) : null;

        return violation;
    }

    public static cls_priorPolicy getPriorPolicy(Property__c property) {
        cls_priorPolicy pp = new cls_priorPolicy();
        pp.carrier = property.Former_Carrier__c;
        pp.expiration = String.valueOf(property.Former_Policy_Expiration__c);

        return pp;
    }

    private static Integer getPrincipalOperator(List<Assigned_Driver__c> vehicleDrivers, List<Driver__c> allDrivers) {
        for(Integer i=0; i<vehicleDrivers.size(); i++) {
            for(Integer j=0; j<allDrivers.size(); j++) {
                if(vehicleDrivers[i].Driver__r.Driver_Contact__c == allDrivers[j].Driver_Contact__c
                    && vehicleDrivers[i].Primary_Driver__c) {
                        return j+1;
                    }
            }
        }
        return 1;
    }

    private static String getValue(String value){
        if(String.isNotBlank(value)){
            return value;
        }
        return '';
    }

    private static decimal getValue(decimal value){
        if(value != null){
            return value;
        }
        return 0;
    }
}