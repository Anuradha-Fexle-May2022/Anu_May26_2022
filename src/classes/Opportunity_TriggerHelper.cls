public with sharing class Opportunity_TriggerHelper {
    //Make a Constant to hold the record names
    static final String CONST_AUTOMOBILE_SENSOR = '00:11:CE:00';
    static final String CONST_AUTOMOBILE_PRESENCE_SENSOR = '00:11:CE:D';
    static final String CONST_AUTOMOBILE_TAG = '00:11:CE:E';
    static final String CONST_AUTOMOBILE_TDU = '111:AB4:ABC';
    
    //Use set and list to add the object fields 
    public static Set<String> sensorsNames = new Set<String>();
    public static List<String> sensorNameList = new List<String>();
    public static void insertRecordsOfAutomobileSensor(List<Opportunity> newList, Map<Id, Opportunity> oldMapopp){
        try{
            
            //use map to hold the related records of automobile sensors
            Map<String, Automobile_Sensor__c> automobileSensor = new Map<String, Automobile_Sensor__c>();
            Map<String, Automobile_Presence_Sensor__c> automobilePresenseSensor = new Map<String, Automobile_Presence_Sensor__c>();
            Map<String, Automobile_TDU__c> automobileTDUSensor = new Map<String, Automobile_TDU__c>();
            Map<String, Automobile_Tag__c> automobileTagSensor = new Map<String, Automobile_Tag__c>();
            
            //Here we are create a new instance of opportunity and check OldMapOpp is not null then get OppId in oldOpp
            Map<String, List<String>> mapOfOppWithAllRecords = new  Map<String,List<String>>();
            for(Opportunity opp : newList){
                Opportunity oldOpp = new Opportunity();
                if(oldMapopp != null){
                    oldOpp = oldMapopp.get(Opp.Id);
                }
                //Here we are checking condition of stage,autombile tag detail 1,2,3 and return to HQ and all records go under installtion account
                if((((opp.StageName == 'Shipped To Customer' || opp.StageName == 'Return To HQ' || opp.StageName == 'Return To Customer')
                && opp.Installation_Account__c != null &&(opp.Automobile_Tag_Details_1__c != null || opp.Automobile_Tag_Details_2__c != null
                || opp.Automobile_Tag_Details_3__c != null || opp.Return_To_HQ__c != null ))))
                {
                    if(!mapOfOppWithAllRecords.containsKey(opp.Id  + '->' + opp.Installation_Account__c)){
                        mapOfOppWithAllRecords.put(opp.Id + '->' + opp.Installation_Account__c, new List<String>());
                    }
                    if(opp.Automobile_Tag_Details_1__c !=null){
                        mapOfOppWithAllRecords.get(opp.Id +'->' + opp.Installation_Account__c).addAll(opp.Automobile_Tag_Details_1__c.split('\n'));
                        sensorNameList.addAll(opp.Automobile_Tag_Details_1__c.split('\n'));
                    }
                    if(opp.Automobile_Tag_Details_2__c !=null){
                        mapOfOppWithAllRecords.get(opp.Id + '->' + opp.Installation_Account__c).addAll(opp.Automobile_Tag_Details_2__c.split('\n'));
                        sensorNameList.addAll(opp.Automobile_Tag_Details_2__c.split('\n'));
                    }
                    if(opp.Automobile_Tag_Details_3__c !=null){
                        mapOfOppWithAllRecords.get(opp.Id + '->' + opp.Installation_Account__c).addAll(opp.Automobile_Tag_Details_3__c.split('\n'));
                        sensorNameList.addAll(opp.Automobile_Tag_Details_3__c.split('\n'));
                    }
                    if(opp.Return_To_HQ__c !=null){
                        mapOfOppWithAllRecords.get(opp.Id + '->' + opp.Installation_Account__c).addAll(opp.Return_To_HQ__c.split('\n'));
                        sensorNameList.addAll(opp.Return_To_HQ__c.split('\n'));
                    }
                    sensorsNames.addAll(sensorNameList);
                }
            }
            system.debug(sensorNameList);
            system.debug(sensorsNames);
            
            //If mapOfOppWithAllRecords is not null then we will insert record in automobile sensor,presence sensor,tag sensor,TDU sensor
            if(mapOfOppWithAllRecords !=null){
                for(String ids : mapOfOppWithAllRecords.keySet()){
                    for(String oppOfNewRecords :mapOfOppWithAllRecords.get(Ids)){
                        
                        List<String> listOfids = new List<String>(ids.split('->'));
                        // For Automobile sensor record
                        Automobile_Sensor__c newSensorRecord = new Automobile_Sensor__c();
                        if(oppOfNewRecords.startsWith(CONST_AUTOMOBILE_SENSOR)){
                            if(oppOfNewRecords.length() > 18){
                                newSensorRecord.Name = oppOfNewRecords.substring(0, 18);
                            }
                            else{
                                newSensorRecord.Name = oppOfNewRecords;
                            }
                            newSensorRecord.Account__c = listOfids[1];
                            newSensorRecord.Opportunity__c = listOfids[0];
                            
                            if(!automobileSensor.ContainsKey(oppOfNewRecords)){
                                automobileSensor.put(oppOfNewRecords, newSensorRecord);
                            }
                        }
                        
                        // For Automobile presence sensor record
                        Automobile_Presence_Sensor__c newPresenceRecord = new Automobile_Presence_Sensor__c();
                        if(oppOfNewRecords.startsWith(CONST_AUTOMOBILE_PRESENCE_SENSOR)){
                            if(oppOfNewRecords.length()>18){
                                newPresenceRecord.Name = oppOfNewRecords.substring(0, 18);
                            }
                            else{
                                newPresenceRecord.Name = oppOfNewRecords;
                            }
                            newPresenceRecord.Account__c = listOfids[1];
                            newPresenceRecord.Opportunity__c = listOfids[0];
                            
                            if(!automobilePresenseSensor.ContainsKey(oppOfNewRecords)){
                                automobilePresenseSensor.put(oppOfNewRecords, newPresenceRecord);
                            }
                        }
                        
                        // For Automobile Tag Record  
                        Automobile_Tag__c newTagRecord = new Automobile_Tag__c();
                        if(oppOfNewRecords.startsWith(CONST_AUTOMOBILE_TAG)){
                            if(oppOfNewRecords.length()>18){
                                newTagRecord.Name = oppOfNewRecords.substring(0, 18);
                            }
                            else{
                                newTagRecord.Name = oppOfNewRecords;
                            }
                            newTagRecord.Account__c = listOfids[1];
                            newTagRecord.Opportunity__c = listOfids[0];
                            
                            if(!automobileTagSensor.ContainsKey(oppOfNewRecords)){
                                automobileTagSensor.put(oppOfNewRecords, newTagRecord);
                            }
                        }
                        // For Automobile TDU Record
                        Automobile_TDU__c newTduRecord = new Automobile_TDU__c();
                        if(oppOfNewRecords.substring(0, 3).isNumeric()){
                            if(oppOfNewRecords.length()>18){
                                newTduRecord.Name = oppOfNewRecords.substring(0, 18);
                            }
                            else{
                                newTduRecord.Name = oppOfNewRecords;
                            }
                            newTagRecord.Account__c = listOfids[1];
                            newTduRecord.Opportunity__c = listOfids[0];
                            
                            if(!automobileTDUSensor.ContainsKey(oppOfNewRecords)){
                                automobileTDUSensor.put(oppOfNewRecords, newTduRecord);
                            }
                        }
                    }
                }                      
            }
            //Performing Insert DML on Automobile sensor
            if(!automobileSensor.values().isEmpty()){
                insert automobileSensor.values();
            }
            //Performing Insert DML on Automobile presence sensor
            if(!automobilePresenseSensor.values().isEmpty()){
                insert automobilePresenseSensor.values();
            }
            //Performing Insert DML on Automobile TDU sensor
            if(!automobileTDUSensor.values().isEmpty()){
                insert automobileTDUSensor.values();
            }
            //Performing Insert DML on Automobile Tag sensor
            if(!automobileTagSensor.values().isEmpty()){
                insert automobileTagSensor.values();
            }  
        }
        catch(DmlException e)
        {
            system.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }
    
    //Here we create a new method to update Installtion account records,Shipment account records and also update records of Shipped to Customer in Return to HQ
    public static void updateSensor(List<Opportunity> listOfNewOpportunity, Map<Id,Opportunity> mapOfOldOpportunity){
        try{
            List<Opportunity> listOpportunity = new List<Opportunity>();
            
            for(Opportunity opp : listOfNewOpportunity){
                if(mapOfOldOpportunity == null || (mapOfOldOpportunity != null && (opp.Automobile_Tag_Details_1__c != mapOfOldOpportunity.get(opp.Id).Automobile_Tag_Details_1__c || opp.Automobile_Tag_Details_2__c != mapOfOldOpportunity.get(opp.Id).Automobile_Tag_Details_2__c || opp.Automobile_Tag_Details_3__c != mapOfOldOpportunity.get(opp.Id).Automobile_Tag_Details_3__c || opp.Return_To_HQ__c !=  mapOfOldOpportunity.get(opp.Id).Return_To_HQ__c  || opp.StageName != mapOfOldOpportunity.get(opp.Id).StageName || opp.Shipment_Account__c != mapOfOldOpportunity.get(opp.Id).Shipment_Account__c)))
                {
                    listOpportunity.add(opp);
                }
            }
            //This map is used for get oldId records of all sensors
            if(listOpportunity.size() > 0){
                Map<String, Automobile_Sensor__c> mapAutomobileSensor = new Map<String, Automobile_Sensor__c>();
                Map<String, Automobile_Presence_Sensor__c> mapAutomobilePresenceSensor = new Map<String, Automobile_Presence_Sensor__c>();
                Map<String, Automobile_Tag__c> mapAutomobileTagSensor = new Map<String, Automobile_Tag__c>();
                Map<String, Automobile_TDU__c> mapAutomobileTDUSensor = new Map<String, Automobile_TDU__c>();
                
                //Querying through list to get all Old records of sensors
                List<Automobile_Sensor__c> automobileSensor = [SELECT Id, Name, Opportunity__c, Account__c,Opportunity__r.Id FROM Automobile_Sensor__c];
                List<Automobile_Presence_Sensor__c> presenceSensor = [SELECT Id, Name, Opportunity__c, Account__c,Opportunity__r.Id FROM Automobile_Presence_Sensor__c];
                List<Automobile_Tag__c> tagSensor = [SELECT Id, Name, Opportunity__c, Account__c,Opportunity__r.Id FROM Automobile_Tag__c];
                List<Automobile_TDU__c> tduSensor = [SELECT Id, Name, Opportunity__c, Account__c,Opportunity__r.Id FROM Automobile_TDU__c];
                
                //This map is use for store the new Values/Id of all records of all sensors
                Map<String, Automobile_Sensor__c> stringOfAutombileSensor = new Map<String, Automobile_Sensor__c>();
                Map<String, Automobile_Presence_Sensor__c> stringOfPresenceSensor = new Map<String, Automobile_Presence_Sensor__c>();
                Map<String, Automobile_Tag__c> stringOfTagSensor = new Map<String, Automobile_Tag__c>();
                Map<String, Automobile_TDU__c> stringOfTduSensor = new Map<String, Automobile_TDU__c>();
                
                for(Automobile_Sensor__c ab : automobileSensor){
                    stringOfAutombileSensor.put(ab.Opportunity__r.Id + ab.Name,ab);
                }
                for(Automobile_Presence_Sensor__c cd : presenceSensor){
                    stringOfPresenceSensor.put(cd.Opportunity__r.Id + cd.Name,cd);
                }
                for(Automobile_Tag__c de : tagSensor){
                    stringOfTagSensor.put(de.Opportunity__r.Id + de.Name,de);
                }
                for(Automobile_TDU__c xy : tduSensor){
                    stringOfTduSensor.put(xy.Opportunity__r.Id + xy.Name,xy);
                }
                
                for(Opportunity opp : listOpportunity){
                    
                    List<String> sensorList = new List<String>();
                    
                    if(opp.Return_To_HQ__c != null){
                        sensorList.add(opp.Return_To_HQ__c.trim() + '\n');
                    }
                    
                    //If Automobile records is not contains then we will update record in automobile sensor,presence sensor,tag sensor,TDU sensor
                    for(String sL : sensorList){
                        for(String s : sL.split('\n')){
                            if(!mapAutomobileSensor.containsKey(opp.Id + s.trim())){
                                mapAutomobileSensor.put(opp.Id + s.trim(), new Automobile_Sensor__c(Name = s.trim(), Account__c = opp.AccountId, Opportunity__c = opp.Id));
                                system.debug(s.trim());
                            }
                            if(!mapAutomobilePresenceSensor.containsKey(opp.Id + s.trim())){
                                mapAutomobilePresenceSensor.put(opp.Id + s.trim(), new Automobile_Presence_Sensor__c(Name = s.trim(), Account__c = opp.AccountId, Opportunity__c = opp.Id));
                            }
                            if(!mapAutomobileTDUSensor.containsKey(opp.Id + s.trim())){
                                mapAutomobileTDUSensor.put(opp.Id + s.trim(), new Automobile_TDU__c(Name = s.trim(), Account__c = opp.AccountId, Opportunity__c = opp.Id));
                            }
                            if(!mapAutomobileTagSensor.containsKey(opp.Id + s.trim())){
                                mapAutomobileTagSensor.put(opp.Id + s.trim(), new Automobile_Tag__c(Name = s.trim(), Account__c = opp.AccountId, Opportunity__c = opp.Id));
                            }
                        }
                    }
                    for(Automobile_Sensor__c assc : stringOfAutombileSensor.values()){
                        if(mapAutomobileSensor.containsKey(opp.Id + assc.Name) && opp.StageName == 'Return To HQ'){
                            stringOfAutombileSensor.get(opp.Id + assc.Name).Account__c = opp.Shipment_Account__c;
                            system.debug(stringOfAutombileSensor);
                        }
                        else if(mapAutomobileSensor.containsKey(opp.Id + assc.Name) && opp.StageName == 'Return To Customer'){
                            stringOfAutombileSensor.get(opp.Id + assc.Name).Account__c = opp.AccountId;
                        }
                    }
                    for(Automobile_Presence_Sensor__c aps : stringOfPresenceSensor.values()){
                        if(stringOfPresenceSensor.containsKey(opp.Id + aps.Name)){
                            stringOfPresenceSensor.get(opp.Id + aps.Name).Account__c = opp.Shipment_Account__c;
                        }
                        else if(mapAutomobilePresenceSensor.containsKey(opp.Id + aps.Name) && opp.StageName == 'Return To Customer'){
                            stringOfPresenceSensor.get(opp.Id + aps.Name).Account__c = opp.AccountId;
                        }
                    }
                    for(Automobile_Tag__c aTagSensor :  stringOfTagSensor.values()){
                        if(stringOfTagSensor.containsKey(opp.Id + aTagSensor.Name)){
                            stringOfTagSensor.get(opp.Id + aTagSensor.Name).Account__c = opp.Shipment_Account__c;
                        }
                        else if(mapAutomobileTagSensor.containsKey(opp.Id + aTagSensor.Name) && opp.StageName == 'Return To Customer'){
                            stringOfTagSensor.get(opp.Id + aTagSensor.Name).Account__c = opp.AccountId;
                        }
                    }
                    for(Automobile_TDU__c aTDUSensor : stringOfTduSensor.values()){
                        if(stringOfTduSensor.containsKey(opp.Id + aTDUSensor.Name)){
                            stringOfTduSensor.get(opp.Id + aTDUSensor.Name).Account__c = opp.Shipment_Account__c;
                        }
                        else if(mapAutomobileTDUSensor.containsKey(opp.Id + aTDUSensor.Name) && opp.StageName == 'Return To Customer'){
                            stringOfTduSensor.get(opp.Id + aTDUSensor.Name).Account__c = opp.AccountId;
                        }
                    }
                }
                system.debug(stringOfAutombileSensor.values());
                
                //Performing Update DML on Automobile sensor
                if(stringOfAutombileSensor.size() > 0){
                    update stringOfAutombileSensor.values();
                }
                //Performing Update DML on Automobile Presence sensor
                if(stringOfPresenceSensor.size() > 0){
                    update stringOfPresenceSensor.values();
                }
                //Performing Update DML on Automobile Tag sensor
                if(stringOfTagSensor.size() > 0){
                    update stringOfTagSensor.values();
                }
                //Performing Update DML on Automobile TDU sensor
                if(stringOfTduSensor.size() > 0){
                    update stringOfTduSensor.values();
                }
            }
        }
        catch(DmlException e)
        {
            system.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }
    
    //Create new method to send email for the all records with successfull and unsuccessfull shipments
    public static void sendingEmails(List<Opportunity> newList){
        try{
            List<String> emailList = new List<String>();
            List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
            Set<String> noSenSet = new Set<String>();
            for(Opportunity opp : newList) {
                String oppOwner = opp.OwnerId;
                String oppName = opp.Name;
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new List<String>{opp.Email__c});
                mail.setSubject(oppName + ' ' + 'Date: '+ Date.today());
                String htmlBody = '';
                htmlBody = '<table border="1" cellpadding="0" style="border-collapse: collapse"><caption>Successful:  </caption><tr><th>Automobile Type</th><th>Name</th><th>Message</th></tr>';
                
                for(String str : sensorsNames) {
                    if(str.startsWith(CONST_AUTOMOBILE_SENSOR)) {
                        htmlBody+= '<tr><td border:"1px solid black">' + 'Sensor ' +'</td><td> '+str+' </td><td>'+'Sensor inserted under installation account id: '+ opp.AccountId +'</td></tr>';
                    }
                    else if(str.startsWith(CONST_AUTOMOBILE_PRESENCE_SENSOR)) {
                        htmlBody+= '<tr><td border:"1px solid black>' + 'Presence Sensor ' +'</td><td> '+str+' </td><td>'+'Sensor inserted under installation account id: '+ opp.AccountId +'</td></tr>';
                    }
                    else if(str.startsWith(CONST_AUTOMOBILE_TAG)) {
                        htmlBody+= '<tr><td border:"1px solid black>' + 'Tag Sensor ' +'</td><td> '+str+' </td><td>'+'Sensor inserted under installation account id: '+ opp.AccountId +'</td></tr>';
                    }
                    else if(str.substring(0,3).isNumeric()) {
                        htmlBody+= '<tr><td border:"1px solid black>' + 'TDU Sensor ' +'</td><td> '+str+' </td><td>'+'Sensor inserted under installation account id: '+ opp.AccountId +'</td></tr>';
                    }
                    else{
                        noSenSet.add(str);
                    }
                }
                htmlBody += '</table>';
                system.debug('Email Body: ' + htmlBody);
                
                String htmlBody2 = '';
                htmlBody2 = '<table border="1" cellpadding="0" cellspacing="1" style="border-collapse: collapse"><caption>Unsuccessful:  </caption><tr><th>Automobile Type</th><th>Name</th><th>Message</th></tr>';
                
                for(String str : noSenSet) {
                    htmlBody2+= '<tr><td>' + 'Sensor ' +'</td><td> '+str+' </td><td> Invalid sensor </td></tr>';
                }
                htmlBody2 += '</table>';
                mail.setHTMLbody(htmlBody + htmlBody2);
                String emailAddress = opp.Email__c;
                System.debug('Email Send Successfully at: ' + emailAddress);
                messages.add(mail);
            }
            Messaging.SendEmailResult[] results = Messaging.sendEmail(  messages );
        }
        catch(DmlException e)
        {
            system.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }
}