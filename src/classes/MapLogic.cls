public with sharing class MapLogic {
    Map<String,Map<String,List<String>>> mapOfCountry = new Map<String,Map<String,List<String>>>();
    List<Country__c> con = [SELECT Country_JSON_Data__c FROM Country__c];
    Country cont = new Country();

    //Fill Country State District Map Dynamically 
    public MapLogic() 
    {
        try
        {
        List<District__c> listOfDistrict = [SELECT Name, State__r.Country__r.Name, State__r.Name FROM District__c];
            for(District__c district : listOfDistrict) 
            {
                if (!mapOfCountry.containskey(district.State__r.Country__r.Name))
                {
                mapOfCountry.put(district.State__r.Country__r.Name, new Map<String,List<String>>());
                }

                if(mapOfCountry != null && mapOfCountry.get(district.State__r.Country__r.Name) != null)
                {
                Map<String,List<String>> mapOfStateWithDistricts = mapOfCountry.get(district.State__r.Country__r.Name);
                if(!mapOfStateWithDistricts.containskey(district.State__r.Name))
                {
                mapOfStateWithDistricts.put(district.State__r.Name, new List<String>());
                }

                if(mapOfStateWithDistricts != null)
                {
                mapOfStateWithDistricts.get(district.State__r.Name).add(district.Name);
                mapOfCountry.put(district.State__r.Country__r.Name, mapOfStateWithDistricts);
                }
                } 
               system.debug('MapOfCountry :' + mapOfCountry); 
            }
        }
        catch (DmlException e)
        {
            system.debug('An unexpected error has occurred: ' + e.getMessage());
        } 
    }

    //1. Find such a District which length is more or equal to some number
    public void findLength()
    {
        try
        {
        for(String gotCountry :mapOfCountry.keyset()){
            if(mapOfCountry.containsKey(gotCountry)){
                for(String gotState :mapOfCountry.get(gotCountry).keyset()){
                    if(mapOfCountry.get(gotCountry).containsKey(gotState)){
                        for(String gotDistrict :mapOfCountry.get(gotCountry).get(gotState)){
                            if(gotDistrict.length() >= 12){
                                system.debug('District :' + gotDistrict);
                            }
                        }
                    }
                }
            }
        }
        }
        catch (DmlException e)
        {
            system.debug('An unexpected error has occurred: ' + e.getMessage());
        }
        
    }
    
    //2. Find a combination of Country, state and districts where it starts with 's'.
    public static void findLetter(String B)
    {
        try
        {
        Map<String,Map<String,List<String>>> mapOfcombinationOfCountry = new Map<String,Map<String,List<String>>>();
        List<District__c> combinationList = [SELECT Name, State__r.Country__r.Name, State__r.Name FROM District__c  WHERE (Name LIKE :B + '%' AND State__r.Name LIKE :B + '%' AND State__r.Country__r.Name LIKE :B + '%')];
        for(District__c district : combinationList) 
        {
            if (!mapOfcombinationOfCountry.containskey(district.State__r.Country__r.Name))
            {
                mapOfcombinationOfCountry.put(district.State__r.Country__r.Name, new Map<String,List<String>>());
            }

            Map<String,List<String>> mapOfStateWithDistricts = mapOfcombinationOfCountry.get(district.State__r.Country__r.Name);
            if(!mapOfStateWithDistricts.containskey(district.State__r.Name))
            {
            mapOfStateWithDistricts.put(district.State__r.Name, new List<String>());
            }

            mapOfStateWithDistricts.get(district.State__r.Name).add(district.Name);
            mapOfcombinationOfCountry.put(district.State__r.Country__r.Name, mapOfStateWithDistricts);
        } 
        system.debug('mapOfcombinationOfCountry :' + mapOfcombinationOfCountry);
        }
        catch (DmlException e)
        {
            system.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }
    

    //Make Wrapper Class for Initilize the Data
    public class Country{
        public String countryName{get;set;}
        public Integer totalNumberOfStates{get;set;}
        public Integer totalNumberOfDistricts{get;set;}
        public Integer CountryCode{get;set;}
    }

    public class States{
        public List<Districts> districts{get;set;}
        public Integer TotalNumberOfDistricts{get;set;}
        public String StateName{get;set;}
    }

    public class Districts{
        public String districtName{get;set;}
    }

    public void CountryStateJSonGenerator(String countryName,Integer countryCode) 
    {
        try
        {
        cont.countryName = countryName;
        cont.countryCode = countryCode;

        List<AggregateResult> totalNumberOfState = [SELECT COUNT(Name) Total_Number_Of_States FROM State__c WHERE Country__r.Name = :countryName  Group By Country__r.Name];  
        cont.totalNumberOfStates =  (Integer)totalNumberOfState[0].get('Total_Number_Of_States');

        List<AggregateResult> totalNumberOfDistrict = [SELECT COUNT(Name) Total_Number_Of_Districts FROM District__c WHERE State__r.Country__r.Name = :countryName Group By State__r.Country__r.Name];    
        cont.totalNumberOfDistricts = (Integer)totalNumberOfDistrict[0].get('Total_Number_Of_Districts');

        for(String state :mapOfCountry.get(countryName).keyset())
        {
            States st = new States();
            st.stateName = state;
            st.districts = new list<Districts>();

        List<AggregateResult> listOfDistrictWithState = [SELECT COUNT(Name)Total_Number_Of_Districts FROM District__c WHERE State__r.Country__r.Name = :countryName Group By State__r.Name]; 
        st.totalNumberOfDistricts = (Integer)listOfDistrictWithState[0].get('Total_Number_Of_Districts');

        for(String dist :mapOfCountry.get(countryName).get(State)) 
        {
            Districts dis = new Districts();
            dis.districtName = dist;
                        
            st.districts.add(dis);
        }    
        }
        }
        catch (DmlException e)
        {
            system.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }
    //Update Data on Country for serialize the JSON
    public void updateCountry()
    {
        try
        {
        for(Country__c name :con)
        {
            name.Country_JSON_Data__c = JSON.serialize(cont);
        }
        update con;
        }
        catch (DmlException e)
        {
            system.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }
}