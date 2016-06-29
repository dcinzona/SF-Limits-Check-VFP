# Salesforce Daily Limits Check
This package is designed to check how close the salesforce org is to reaching their daily allowed governor limits.  The results are provided via the Salesforce.com REST API: Limits endpoint.  Not all limits are returned via this endpoint, but as Salesforce makes changes and adds more items, the class will continue to function and record those new items.

## VisualForce Page Setup
The VisualForce page only requires that the static resources be added to the org.  If the name used differs from what is provided in the repo, please update the VisualForce page to match.

*Please note, the user must have the correct permissions in order to view the limits.*

![VisualForce page screenshot](https://raw.githubusercontent.com/dcinzona/SF-Limits-Check-VFP/master/VisualForcePage-Screenshot.png)

## Batch Setup
In order to get the batch process working correctly, there are several steps that must be taken.

1. Create a new Self-Signed certificate.  This certificate will be used for signing the JWT OAUTH token.
2. Create a service user account (or designate a user account that can be used for the batch process).
3. Create a Connected App and enable OAUTH.  The Redirect URI is not important. Select the correct OAUTH scopes:
  * `Access and Manage your Data`
  * `Perform requests on your behalf at any time (offline access)`
4. Edit the Connect App and set the OAUTH policy for Permitted Users to `Admin approved users are pre-authorized`
5. Check 'Use Digital Signatures' and select the certificate created in step 1.
6. Add the following remote sites:
  * https://login.salesforce.com/
  * https://(your_org).my.salesforce.com/
7. Create an new Profile for API access and add the connected app (this will pre-approve the user for OAUTH access)
8. Edit the `ApexLimitsChecker.apxc` apex class and update the static variables to match those created in steps 1, 2, 3 (client_id)
9. Test (run anonymous: `ApexLimitsChecker.GetLimitsListFromApi();`). You should have some debug logs, one of which should be the JSON response from the API.
