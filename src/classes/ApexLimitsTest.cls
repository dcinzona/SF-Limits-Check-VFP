//This is not a test class
public class ApexLimitsTest {
    public static List<Limit__c> GetRecordsWrittenWithinAnHour(){
        DateTime now = system.now().addHours(-1);
        system.debug('now: '+now);

        List<Limit__c> mostRecent = [Select Id, Recorded_Date_Time__c From Limit__c
                                     Where Recorded_Date_Time__c >= :now
                                     Order By Recorded_Date_Time__c DESC
                                     Limit 1];
        system.debug(mostRecent);
        integer q = Limits.getQueries();
        system.debug('queries: '+q);
        return mostRecent;
    }
}
