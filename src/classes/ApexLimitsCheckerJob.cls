global class ApexLimitsCheckerJob implements Schedulable {
    global void execute(SchedulableContext ctx) {
            List<Limit__c> mostRecent = [Select Id, Recorded_Date_Time__c From Limit__c 
                                     Where Recorded_Date_Time__c >= :DateTime.now().addHours(-1)
                                     Order By Recorded_Date_Time__c DESC 
                                     Limit 1];
            if(!mostRecent.isEmpty()){
                System.debug('Not enough time has passed.  Last recorded record was for ' +
                             mostRecent[0].Recorded_Date_Time__c);
                return;
            }
        	ApexLimitsChecker.GetLimitsResult();
        }
}