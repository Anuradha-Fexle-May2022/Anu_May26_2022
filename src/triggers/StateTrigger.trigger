trigger StateTrigger on State__c (after insert,after update,after delete,after undelete) {
    if(Trigger.isafter){
        if(Trigger.isInsert || Trigger.isUpdate || Trigger.isDelete){
            StateTriggerHandler.countryStateCountNumber(Trigger.new,Trigger.old);
        }
    }
}