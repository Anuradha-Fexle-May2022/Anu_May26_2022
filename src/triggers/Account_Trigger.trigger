trigger Account_Trigger on Account (before insert,before update) {
    if(trigger.isBefore){
        if(trigger.isInsert || trigger.isUpdate){
            Account_TriggerHelper.accountStatus(Trigger.new);
        }
    }
}