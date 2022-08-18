public with sharing class DistrictTriggerHandler {
    public static void districtStateTrigger(List<District__c> newList, List<District__c> oldList) {
        try{
            //List to add state and Id on District 
            List<State__c> addState = new List<State__c>();
            List<id> addDistrict = new List<id>();
            //To fill State Id into addDistrict List into newList
            for (District__c district : newList){
                addDistrict.add(district.State__c);
            }
            system.debug('addDistrict :'+addDistrict);
            
            //To fill State Id into addDistrict List into OldList
            if(oldList != null){
                for (District__c district : oldList){
                    addDistrict.add(district.State__c);
                }
            }
           
            //Set to hold records from Related records and querying Total number of District from States
            Set<Id> countryIdSet = new Set<Id>();
                for (State__c st : [SELECT Id, Country__r.Id, Total_Number_of_Districts__c,(SELECT Id FROM Districts__r) from State__c where id IN :addDistrict]){
                    st.Total_Number_of_Districts__c = st.Districts__r.size();
                    addState.add(st);
                    countryIdSet.add(st.Country__r.Id);
                }
            system.debug('addDistrict :'+addDistrict);
            //Update the list 
            if(addState.size() > 0){
                update addState;
            }
            //Using Map to get Country code,Total Number of District and Total Number of States from country 
            Map<Id, Country__c> mapOfCountryWithDistrict = new Map<Id, Country__c>([SELECT Id, Name, Country_Code__c,Total_Number_Of_Districts__c,Total_Number_Of_States__c FROM Country__c WHERE Id IN :countryIdSet]);
            //Checking and querying our aggregate function
            for (AggregateResult country : [SELECT Country__c, sum(Total_Number_Of_Districts__c)Total_Districts FROM State__c WHERE Country__r.Id IN :mapOfCountryWithDistrict.keySet() Group By Country__c])
            {
                Id countryId = (Id)country.get('Country__c');
                for(Country__c cont : mapOfCountryWithDistrict.values()){
                    if(countryId == cont.Id){
                        cont.Id = countryId;
                        cont.Total_Number_Of_Districts__c = (Decimal)country.get('Total_Districts');
                        updateJSON(cont.Name, Integer.ValueOf(cont.Country_Code__c));
                    }
                }
            }
            if(mapOfCountryWithDistrict.size() > 0){
                update mapOfCountryWithDistrict.values();
            }
        }
        catch(DmlException e)
        {
            system.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }
    
    //Create a method to update JSON Generator and Call the JSON from previous apex class
    public static void updateJSON(String countryName,Integer countryCode){
        try{
            MapLogic ml = new MapLogic();
            ml.CountryStateJSonGenerator(countryName,countryCode);
        }
        catch(DmlException e)
        {
            system.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }
}