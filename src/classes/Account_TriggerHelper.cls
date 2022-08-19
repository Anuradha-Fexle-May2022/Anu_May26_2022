public with sharing class Account_TriggerHelper {
    public static void accountStatus(List<Account> accountList) {
        set<Id> setOfPropertyId = new set<Id>();
        for(Account acc : accountList){
            //Check the status of Account 
            if(acc.Status__c == null){
                //Add the Property Id in Set
                setOfPropertyId.add(acc.Property__c);
            }
        }
        system.debug(setOfPropertyId);
        Map<id,Property__c> propertyMap = new Map <id, Property__c> ([SELECT Id, Status__c FROM Property__c WHERE Id IN :setOfPropertyId]);
        system.debug(propertyMap);
        for(Account act : accountList){
            Property__c prop = propertyMap.get(act.Property__c);
            if(prop.Status__c != null){
                //Assign Property status on Account status
                act.Status__c = prop.Status__c;
            }
        }
    }
}