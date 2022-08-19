trigger Opportunity_Trigger on Opportunity (after insert, after update) {
    if(trigger.isAfter){
        if(trigger.isInsert){
            Opportunity_TriggerHelper.insertRecordsOfAutomobileSensor(Trigger.new,Trigger.oldMap);
            Opportunity_TriggerHelper.sendingEmails(Trigger.new);
        }
        if(trigger.isUpdate){
            Opportunity_TriggerHelper.updateSensor(Trigger.new,Trigger.oldMap);
        }
    }   
}