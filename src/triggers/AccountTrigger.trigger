//Make a before insert, after insert, before update, after update event trigger 
trigger AccountTrigger on Account (before insert, after insert, before update, after update){
    //In this condition we can use Before insert trigger 
    if(Trigger.isInsert){
        if(Trigger.isBefore){
            AccountTriggerHandler.insertAccountDetails(Trigger.new);
            AccountTriggerHandler.rating(Trigger.new);
        }
        //In this condition we can use After insert trigger
        if(Trigger.isAfter){
            AccountTriggerHandler.sendingEmails(Trigger.new);
            AccountTriggerHandler.createdRelatedOpp(Trigger.new);
        }
    }

    //In this condition we can use Before update trigger
    if(Trigger.isUpdate){
        if(Trigger.isBefore){
            AccountTriggerHandler.updatePhoneDescription(Trigger.new, Trigger.oldMap);
        }
        //In this condition we can use After update trigger
        if(Trigger.isAfter){
            AccountTriggerHandler.updateRelatedOppPhone(Trigger.new, Trigger.oldMap);
        }
    }
}