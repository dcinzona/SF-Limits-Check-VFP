public with sharing class ApexLimitsChecker {
    private static final String PRE_CREATED_CERTIFICATE_NAME = '<NAME OF SELF SIGNED SECURITY CERT>';
    private static final String USERNAME = '<YOUR SERVICE ACCOUNT USERNAME HERE>';
    private static final String CLIENT_ID = '<CONNECTED APP OAUTH CLIENT ID>';
    private static final string ORG_HOSTNAME = '<ORG HOSTNAME TO QUERY>';

    @AuraEnabled
    public static string getJWTAccessToken(){
        Jwt.Configuration config = new Jwt.Configuration();
        config.jwtUsername = USERNAME;
        config.jwtSigningCertificateName = PRE_CREATED_CERTIFICATE_NAME;
        config.jwtHostname = 'login.salesforce.com';
        config.jwtConnectedAppConsumerKey = CLIENT_ID;

        String accessToken = new Jwt(config).requestAccessToken();
        system.debug('JWT Access Token: ' + accessToken);
        return accessToken;
    }

    @AuraEnabled
    public static String GetLimitsJson(string hostName, string accessToken){

        if(accessToken == null){
            accessToken = ApexLimitsChecker.getJWTAccessToken();
        }

        Http h = new Http();
        String endPoint = 'https://'+hostName+'/services/data/v36.0/limits/';
        HttpRequest req1 = new HttpRequest();
        req1.setMethod('GET');
        req1.setHeader('Authorization','Bearer ' + accessToken);
        req1.setHeader('Content-Type','application/json');
        req1.setHeader('accept','application/json');
        req1.setEndpoint(endPoint);
        HttpResponse res1 = h.send(req1);
        system.debug(res1.getbody());
        return res1.getBody();
    }

    public static List<Limit__c> GetLimitsListFromApi(){
        DateTime recordDate = DateTime.now();
        String limits = ApexLimitsChecker.GetLimitsJson('gmt-acumen-demo-org.my.salesforce.com',null);
        JSONParser parser = JSON.createParser(limits);
        List<Limit__c> records = new List<Limit__c>();
        String currentObjectName = null;
        Integer Max = null;
        Integer Remaining = null;
        String previousObjectName = null;
        Limit__c limitObject;
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                string fieldName = parser.getCurrentName();
                if(fieldName != 'Max'
                   && fieldName != 'Remaining'
                   && fieldName != currentObjectName){
                    previousObjectName = currentObjectName;
                    currentObjectName = fieldName;
                    limitObject = new Limit__c();
                    limitObject.LimitName__c = currentObjectName;
                    limitObject.Recorded_Date_Time__c = recordDate;
                }
                if(parser.getCurrentName() == 'Max'){
                	parser.nextValue();
                    Max = parser.getIntegerValue();
                    limitObject.Max__c = Max;
                }
                if(parser.getCurrentName() == 'Remaining'){
                	parser.nextValue();
                    Remaining = parser.getIntegerValue();
                    limitObject.Remaining__c = Remaining;
                    records.add(limitObject);
                    limitObject = null;
                }
            }
        }
        return records;
    }
}