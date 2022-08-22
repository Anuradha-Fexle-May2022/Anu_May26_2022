public with sharing class Account_TriggerHelper {
    public static void accountStatus(List<Account> accountList) {
        Set<Id> setOfPropertyId = new Set<Id>();
        for(Account acc : accountList){
            //Check the status of Account 
            if(acc.Status__c == null){
                //Add the Property Id in Set
                setOfPropertyId.add(acc.Property__c);
            }
        }
        //Create Map of id and Property and do query on Property
        Map<Id, Property__c> propertyMap = new Map<Id, Property__c> ([SELECT Id, Status__c FROM Property__c WHERE Id IN: setOfPropertyId]);
        for(Account act : accountList){
            if(propertyMap.containsKey(act.Property__c)){
                Property__c prop = propertyMap.get(act.Property__c);
                if(prop.Status__c != null){
                    //Assign Property status on Account status
                    act.Status__c = prop.Status__c;
                } 
            }
        }
    }
}