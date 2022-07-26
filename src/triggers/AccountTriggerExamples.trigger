//Make a before insert, after insert, before update, after update event trigger 
trigger AccountTriggerExamples on Account (before insert, after insert, before update, after update) {
    //In this condition we can use Before insert trigger 
    if(Trigger.isInsert){
        if(Trigger.isBefore){
            AccTriggerHelper1.rating(Trigger.new);
        }
        //In this condition we can use After insert trigger
        if(Trigger.isAfter){
            AccTriggerHelper1.createdRelatedOpp(Trigger.new);
        }
    }
    //In this condition we can use Before update trigger
    if(Trigger.isUpdate){
        if(Trigger.isBefore){
            AccTriggerHelper1.updatePhoneDescription(Trigger.new, Trigger.oldMap);
        }
        //In this condition we can use After update trigger
        if(Trigger.isAfter){
            AccTriggerHelper1.updateRelatedOppPhone(Trigger.new, Trigger.oldMap);
        }
    }
}