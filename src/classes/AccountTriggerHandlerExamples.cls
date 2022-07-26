//In this we make a class and their different methods using different events
public with sharing class AccountTriggerHandlerExamples {
    //In this method we use Before Insert event and make a list of Account
    public static void rating(List<Account> newList){
        //If Account Industry is not null and having value as 'Media' then populate Rating as 'Hot' otherwise 'cold'
        for(Account acc : newList){
            if(acc.Industry != null && acc.Industry == 'Media'){
                acc.Rating = 'Hot';
            }
            else{
                acc.Rating = 'Cold';
            }
        }
    }
    
    //In this method we use After Insert event 
    public static void createdRelatedOpp(List<Account> newList){
        
        List<Opportunity> oppToBeInserted = new List<Opportunity>();
        //Created Related Opportunity when Account is created
        for(Account acc : newList){
            Opportunity opp = new Opportunity();
            opp.Name = acc.Name;
            opp.AccountId = acc.Id;
            opp.StageName = 'Prospecting';
            opp.CloseDate = System.today();
            oppToBeInserted.add(opp);
        }
        //In this we use insert DML opertaion 
        if(!oppToBeInserted.isEmpty()){
            insert oppToBeInserted;
        }
    }
    
    //In this method we use Before Update event
    public static void updatePhoneDescription(List<Account> newList, Map<Id,Account> oldMap){
        //If Account PHone is updated then put update message in description
        for(Account acc : newList){
            //In this firstly we can check the condition of oldMap and account phone
            if(oldMap != null && acc.Phone != oldMap.get(acc.Id).Phone){
                acc.Description = 'Phone is modified on Account';
            }
        }
    }
    //In this method we use After Update event
    public static void updateRelatedOppPhone(List<Account> newList, Map<Id,Account> oldMap){
        Map<Id, Account> accIdToAccountMap = new  Map<Id, Account>();
        List<Opportunity> oppToBeUpdated = new List<Opportunity>();
        //If Account phone is updated then populate that on all relateed opportunities
        for(Account acc : newList){
            //In this firstly we can check the condition of oldMap and account phone
            if(oldMap != null && acc.Phone != oldMap.get(acc.Id).Phone){
                //This map will be having account id and account record where phone field is modified and their all information are having in map
                accIdToAccountMap.put(acc.id,acc);
            }
        }
        //In this we can do SOQL query in this all the opportunity records will be queried where account id is in the keyset
        for(Opportunity opp : [SELECT Id, Account_Phone__c, AccountId FROM Opportunity WHERE AccountId IN : accIdToAccountMap.keyset()]){
            //Through this opportunitity we can fetch account id 
            Opportunity oppor = new Opportunity();
            if(accIdToAccountMap.containsKey(opp.AccountId)){
                oppor.id = opp.id;
                //In this we  can do that from all complete record we can just find phone record and the record is saved already for that we make a custom field of phone on opportunity
                oppor.Account_Phone__c = accIdToAccountMap.get(opp.AccountId).Phone;
                oppToBeUpdated.add(oppor);
            }
        }
        //Check the condition if oppToBeUpdated is not empty then we can apply Update DML operation
        if(!oppToBeUpdated.isEmpty()){
            update oppToBeUpdated;
        }
    }
}