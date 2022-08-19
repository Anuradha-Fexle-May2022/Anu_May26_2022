public with sharing class ContactTriggerHandler {
    public static void propertyAccountStatus(List<Contact> contactList) {
        set<Id> setOfId = new set<Id>();
        for(Contact con : contactList){
            setOfId.add(con.AccountId);
        }
        Map<id,Account> accountMap = new Map <Id, Account> ([SELECT Id, Status__c, Property__r.Status__c FROM Account WHERE Id IN: setOfId]);
        for(Contact con : contactList){
            if(con.Status__c == Null){
                Account acc = new Account();
                acc = accountMap.get(con.AccountId);
                if(acc.Status__c != Null){
                    con.Status__c = acc.Status__c;
                }
                else if(acc.Status__c == Null ){
                    if(acc.Property__r.Status__c != null){
                        con.Status__c = acc.Property__r.Status__c;
                    }
                }
            }
        }
    }
}