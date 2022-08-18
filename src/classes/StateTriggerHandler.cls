public with sharing class StateTriggerHandler {
    public static void countryStateCountNumber(List<State__c> newList, List<State__c> oldList){
        try{
            //List to add country and Id on State 
            List<Country__c> addCountry = new List<Country__c>();
            List<id> addStateId = new List<id>();
            //To fill Country Id into addState List into newList
            for (State__c state : newList){
                addStateId.add(state.Country__c);
            }
            //To fill Country Id into addState List into OldList
            if(oldList != null){
                for (State__c state : oldList){
                    addStateId.add(state.Country__c);
                }
            }
            //querying Total number of State from Country
            for (Country__c ct : [SELECT Id, Name, Country_Code__c, Total_Number_of_States__c,(SELECT Id FROM States__r) from Country__c where id IN :addStateId]){
                ct.Total_Number_of_States__c = ct.States__r.size();
                addCountry.add(ct);
                updateJSON(ct.Name, Integer.ValueOf(ct.Country_Code__c));
            }
            if(addCountry.size() > 0){
                update addCountry;
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