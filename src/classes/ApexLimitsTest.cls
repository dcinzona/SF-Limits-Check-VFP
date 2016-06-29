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
    
    public static void testLimitsOrgSettingMetadataType(){
        List<Limits_Org_Setting__mdt> orgs = [Select 
                                              DeveloperName
                                              From Limits_Org_Setting__mdt
                                              Where Enabled__c = true];
        for(Limits_Org_Setting__mdt org : orgs){
            system.debug('>>> org name: ' + org.DeveloperName);
            string orgurl = org.Org_URL__c;
            string certName = org.Digital_Certificate_Name__c;
            string username = org.Username__c;
            string clientId = org.Connect_App_Client_ID__c;
            string accesstoken = getJWTAccessToken(username, certName, clientId);
        }
    }
    public static string getJWTAccessToken(string USERNAME, string PRE_CREATED_CERTIFICATE_NAME, string CLIENT_ID){
        Jwt.Configuration config = new Jwt.Configuration();
        config.jwtUsername = USERNAME;
        config.jwtSigningCertificateName = PRE_CREATED_CERTIFICATE_NAME;
        config.jwtHostname = 'login.salesforce.com';
        config.jwtConnectedAppConsumerKey = CLIENT_ID;

        String accessToken = new Jwt(config).requestAccessToken();
        system.debug('JWT Access Token: ' + accessToken);
        return accessToken;
    }
    
    public static void testLimitsOrgToCheckCustomObject(){
		List<Limits_Org_To_Check__c> orgs = [Select 
                                             Name,
                                             Org_Url__c,
                                             Username__c,
                                             Password__c,
                                             JWT_Certificate_Name__c
                                             From Limits_Org_To_Check__c 
                                             WHERE Enabled__c = true];
        for(Limits_Org_To_Check__c org : orgs){
            
        }
    }
    
    public static void testNamedCredentials(){
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Acumen_Demo_Limits_API/services/data/v36.0/limits');
        //req.setEndpoint('callout:gmt_dev_ed/services/data/v36.0/limits');
        //req.setHeader('Authorization', value)
        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug( req.toString() );
        System.debug(res.getBody());
    }
}