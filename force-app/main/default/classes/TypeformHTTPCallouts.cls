/* Class Name: TypeformHTTPCallouts
* Consist of all methods to fetch information from Typeform
* Created Date: 16-04-2019
*/
public class TypeformHTTPCallouts {
    private static string strAccessToken;
    private static string strBaseURL;
    
    //Method checks and sets Access Token from Custom Settings
    public static boolean Initialize()
    {
        try
        {
            List<Typeform_Settings__c> lstGCLCustomSettings = Typeform_Settings__c.getAll().values();
          	
            if(null != lstGCLCustomSettings[0])
            {
                strAccessToken = lstGCLCustomSettings[0].Access_Token__c;
                strBaseURL = lstGCLCustomSettings[0].Base_URL__c;                
            }
            
            if(strAccessToken != null && strBaseURL != null)
                return true;
            else
            {
                Logger.Log('Error','Access Token or Base URL is Missing in custom settings.', 'TypeformHTTPCallouts.Initialize', '');    
                return false;
            }  
        }
        catch(Exception oEx)
        {
            Logger.Log('Error','Line Number: ' + oEx.getLineNumber() + ' Message: ' + oEx.getMessage(), 'TypeformHTTPCallouts.Initialize', '');    
            return false;
        }
    }
    
    //Method to get form details for single form
    public static TypeformWrapper GetSingleFormDetails(string typeformId)
    {
        try
        {
            TypeformWrapper ReturnedData = new TypeformWrapper();

            HTTPResponse response;
            response = TypeformHTTPCallouts.ExecuteTypeformHTTPCallout('forms/' + typeformId, 'GET', null);
            
            ReturnedData = (TypeformWrapper)System.JSON.deserialize(response.getBodyAsBlob().toString(), TypeformWrapper.class);
            system.debug('ReturnedData after JSON deserialization: ' + ReturnedData);
            
            return ReturnedData;
        }
        catch(Exception oEx)
        {
            Logger.Log('Error','Line Number: ' + oEx.getLineNumber() + ' Message: ' + oEx.getMessage(), 'TypeformHTTPCallouts.GetSingleFormDetails', '');    
            system.debug('Error: ' + 'Line Number: ' + oEx.getLineNumber() + ' Message: ' + oEx.getMessage());
            return null;
        }        
    }
    
    //generic method to use for HTTP Callouts. Just create correct endpoint append string that will be added to Base URL
    // And Request Body.
    private static HTTPResponse ExecuteTypeformHTTPCallout(string strEndpoint, string httpmethod, string requestBody)
    {
        try
        {
            If(Initialize())
            {
                Http http = new Http();
                HTTPRequest request = new HTTPRequest();
                request.setEndpoint(strBaseURL + '/' + strEndpoint);
                request.setMethod(httpmethod);
                request.setHeader('Authorization', 'Bearer ' + strAccessToken); 
                request.setHeader('Accept', 'application/json');
                if(requestBody != null)
                    request.setBody(requestBody);
                HTTPResponse response = http.send(request);
                String strResponse = String.valueOf(response.getBodyAsBlob().toString());
                system.debug('Typeform Response Body: ' + strResponse);
                return response;
            }
            else
                Logger.Log('Error','Initialization From custom Settings Failed..', 'TypeformHTTPCallouts.ExecuteTypeformHTTPCallout', '');    
            
        }
        catch(Exception oEx)
        {
            Logger.Log('Error','Line Number: ' + oEx.getLineNumber() + ' Message: ' + oEx.getMessage(), 'TypeformHTTPCallouts.ExecuteTypeformHTTPCallout', '');    
        }
        return null;   
    }
}