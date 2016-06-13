global class ApexLimitsCheckBatchScheduler implements Schedulable{
    global void execute(SchedulableContext ctx) {
        ApexLimitsCheckBatch p = new ApexLimitsCheckBatch();
        database.executeBatch(p);
    }   
}