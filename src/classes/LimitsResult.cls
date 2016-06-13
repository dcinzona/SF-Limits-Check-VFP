public class LimitsResult {
    public class LimitItem {
        public integer Max;
        public integer Remaining;
    }
    public LimitItem ConcurrentAsyncGetReportInstances  { get; set; }
    public LimitItem ConcurrentSyncReportRuns  {  get;set;  }
    public LimitItem DailyApiRequests {  get;set;  }
    public LimitItem DailyAsyncApexExecutions { get;set; }
    public LimitItem DailyBulkApiRequests {  get;set;  }
    public LimitItem DailyDurableGenericStreamingApiEvents  {  get;set;  }
    public LimitItem DailyGenericStreamingApiEvents  {  get;set;  }
    public LimitItem DailyStreamingApiEvents  {  get;set;  }
    public LimitItem DailyWorkflowEmails {  get;set;  }
    public LimitItem DataStorageMB {  get;set;  }
    public LimitItem DurableStreamingApiConcurrentClients {  get;set;  }
    public LimitItem FileStorageMB {  get;set;  }
    public LimitItem HourlyAsyncReportRuns {  get;set;  }
    public LimitItem HourlyDashboardRefreshes {  get;set;  }
    public LimitItem HourlyDashboardResults {  get;set;  }
    public LimitItem HourlyDashboardStatuses {  get;set;  }
    public LimitItem HourlySyncReportRuns {  get;set;  }
    public LimitItem HourlyTimeBasedWorkflow {  get;set;  }
    public LimitItem MassEmail {  get;set;  }
    public LimitItem SingleEmail {  get;set;  }
    public LimitItem StreamingApiConcurrentClients {  get;set;  }
}