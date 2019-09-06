/* Class Name: TypeformBatchGetFormDetails
* TypeformBatchGetFormDetails batch class fetches the latest details for given typeform form along with fields
* Created Date: 19-04-2019
*/
global class TypeformBatchGetFormDetails implements 
Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts{
    // instance member to retain state across transactions
    global boolean isAccessTokenPresent = false;
    //Batch will process data received from Typeform Callouts, so nothing needs to be queried from SFDC for now.
    //Just checking if Acces token and base url exists in custom settings.
    global Database.QueryLocator start(Database.BatchableContext bc) {
        try
        {   
            List<Typeform_Settings__c> lstGCLCustomSettings = Typeform_Settings__c.getAll().values();
            string strAccessToken;
            string strBaseURL;     
            
            if(null != lstGCLCustomSettings[0])
            {
                strAccessToken = lstGCLCustomSettings[0].Access_Token__c;
                strBaseURL = lstGCLCustomSettings[0].Base_URL__c;                
            }
            
            if(strAccessToken != null && strBaseURL != null)
            {
                //We are good to go
                isAccessTokenPresent = true;
            }
            else
            {
                isAccessTokenPresent = false;
                Logger.Log('Error','Access Token or Base URL is Missing in custom settings.', 'typeformBatchGetFormDetails.Start', null);
            }  
            
            system.debug('isAccessTokenPresent: ' + isAccessTokenPresent);
            
        }
        catch(Exception oEx)
        {
            Logger.Log('Error','Line Number: ' + oEx.getLineNumber() + ' Message: ' + oEx.getMessage(), 'typeformBatchGetFormDetails.Start', null);    
        }     
        
        //dummy query call for getting valid QueryLocator.
        string query = 'SELECT ID From Account Limit 1';
        return Database.getQueryLocator(query);
    }
    
    //Batch executes the GetAllCustomer Callouts and then upserts the details received into account object.
    global void execute(Database.BatchableContext bc, List<Account> scope){
        try
        {
            system.debug('Inside execute isAccessTokenPresent: ' + isAccessTokenPresent);
            
            //Form Id is Hardcoded here. We will make this generic in the next phase if Second Home Agrees.
            boolean isSuccessful = TypeformUtilityClass.CreateSingleFormAndFields('fNyeNI');
           system.debug('Batch Callout to Typform returned isSuccessful: ' + isSuccessful);
        }
        catch(Exception oEx)
        {
            Logger.Log('Error','Line Number: ' + oEx.getLineNumber() + ' Message: ' + oEx.getMessage(), 'typeformBatchGetFormDetails.Execute', null);    
        }
    } 
    
    global void finish(Database.BatchableContext bc){
        try
        {
            system.debug('Inside Finish');   
        }
        catch(Exception oEx)
        {
            Logger.Log('Error','Line Number: ' + oEx.getLineNumber() + ' Message: ' + oEx.getMessage(), 'typeformBatchGetFormDetails.Finish', null);    
        }
    }    
}