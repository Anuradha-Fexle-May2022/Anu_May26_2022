//Make a class and their different methods using different events
public with sharing class AccountTriggerHandler {
    //Create a method for beforeInsert Event and use condition for Saving account and Fixed account
    public static void insertAccountDetails(List<Account> newList){
        try{
            if(newList.size() > 0)
            {
                for(Account acc : newList){
                    if(acc.Account_Details__c == 'Saving Account'){
                        acc.AccountNumber = 'SA-' + acc.AccountNumber;
                    }
                    if(acc.Account_Details__c == 'Fixed Account'){
                        acc.AccountNumber = 'FA-' + acc.AccountNumber;
                    }
                }
            }
        }
        catch (DmlException e)
        {
            system.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }
    //Create a method for afterInsert Event
    public static void sendingEmails(List<Account> newList){
        try{
            //Create a master list to hold the emails we will send
            List<Messaging.SingleEmailMessage > listOfEmail = new List<Messaging.SingleEmailMessage >();
            for(Account acc : newList)
            {
                //Create a new Email
                Messaging.SingleEmailMessage  email = new Messaging.SingleEmailMessage (); 
                List<String> toAddress = new List<String>{acc.Email_Address__c};
                if(toAddress.size() > 0)
                {
                    email.setToAddresses(toAddress);
                    email.setSubject('Congratulation :' + acc.Name);
                    String body = 'Dear, ' + acc.Name + '<br>' + ' Welcome to Axis Bank ' + '<br>' + 'Your Account Has Been Updated' + 'Your Account Number is' + acc.AccountNumber + '<br>' + 'If you have any query feel free to ask on 18006780067' + '<br>' +'Thanking You';
                    email.setHtmlBody(body);
                    //Add email to the master list
                    listOfEmail.add(email);
                }
            }
            //Send all emails in the master list
            if(listOfEmail.size() > 0)
            {
                Messaging.sendEmail(listOfEmail);
            }
        }
        catch(DmlException e) 
        {
            system.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }

    //Try Examples
    //Using Before Insert event and make a list of Account
    public static void rating(List<Account> newList){
        try{
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
        catch(DmlException e)
        {
            system.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }
    
    //Using After Insert event 
    public static void createdRelatedOpp(List<Account> newList){
        try{
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
        //Using insert DML opertaion 
        if(!oppToBeInserted.isEmpty()){
            insert oppToBeInserted;
        }
    }
    catch(DmlException e)
    {
        system.debug('An unexpected error has occurred: ' + e.getMessage());
    }
    }
    
    //Using Before Update event
    public static void updatePhoneDescription(List<Account> newList, Map<Id,Account> oldMap){
        try{
        //If Account PHone is updated then put update message in description
        for(Account acc : newList){
            //In this firstly we can check the condition of oldMap and account phone
            if(oldMap != null && acc.Phone != oldMap.get(acc.Id).Phone){
                acc.Description = 'Phone is modified on Account';
            }
        }
    }
    catch(DmlException e)
    {
        system.debug('An unexpected error has occurred: ' + e.getMessage());
    }
    }
    //Using After Update event
    public static void updateRelatedOppPhone(List<Account> newList, Map<Id,Account> oldMap){
        try{
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
        //Using SOQL query in this all the opportunity records will be queried where account id is in the keyset
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
    catch(DmlException e)
    {
        system.debug('An unexpected error has occurred: ' + e.getMessage());
    }
    }
}