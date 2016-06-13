global class ApexLimitsCheckBatch implements Database.Batchable<Limit__c>, 
Database.AllowsCallouts{
    
    global Iterable<Limit__c> start(Database.BatchableContext bc) {
        //originally set this to an hour, but the batch runns every hour 
        //(and sometimes late due to SF resources)
        Datetime d = DateTime.now().addMinutes(-20); 
        List<Limit__c> mostRecent = [Select Id, Recorded_Date_Time__c From Limit__c 
                                     Where Recorded_Date_Time__c >= :d
                                     Order By Recorded_Date_Time__c DESC 
                                     Limit 1];
        if(!mostRecent.isEmpty()){
            System.debug('>>> Not enough time has passed since the last apex limits where recorded.');
        	return new List<Limit__c>();
        }
        return ApexLimitsChecker.GetLimitsListFromApi();
        /*

        String query = 'SELECT Id FROM Limit__c WHERE Recorded_Date_Time__c > '+
            d.format('yyyy-MM-dd')+'T'+
            d.format('HH:mm')+':00.000Z '+
            'Limit 1';
        return Database.getQueryLocator(query);
		*/
    }
    
    global void execute(Database.BatchableContext BC, list<Limit__c> records){
        if(records.isEmpty()){
            System.debug('>>> Not enough time has passed since the last apex limits where recorded.');
        }else{
            system.debug('>>> Adding new records...');
        	insert records;
        }
    }
    
    global void finish(Database.BatchableContext BC){
        system.debug('>>> Batch complete.');
    }
    
}