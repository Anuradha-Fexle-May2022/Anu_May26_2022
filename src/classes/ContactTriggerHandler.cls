public with sharing class ContactTriggerHandler {
    public static void propertyAccountStatus(List<Contact> contactList) {
        Set<Id> setOfId = new Set<Id>();
        //Create a new instance on Contact and add AccountId in setOfId
        for(Contact con : contactList){
            setOfId.add(con.AccountId);
        }
        //Create a Map on Account Id and querying on Account
        Map<Id,Account> accountMap = new Map <Id, Account> ([SELECT Id, Status__c, Property__r.Status__c FROM Account WHERE Id IN: setOfId]);
        for(Contact con : contactList){
            //If Contact status is null and related account status is not null then fill Contact status with account status
            if(con.Status__c == Null){
                Account acc = new Account();
                acc = accountMap.get(con.AccountId);
                if(acc.Status__c != Null){
                    con.Status__c = acc.Status__c;
                }
                //If Contact status is null and related property status is not null then fill Contact status with property status
                else if(acc.Status__c == Null ){
                    if(acc.Property__r.Status__c != null){
                        con.Status__c = acc.Property__r.Status__c;
                    }
                }
            }
        }
    }
}