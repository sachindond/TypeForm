/* Class Name: TypeformCreateContactRESTService
* TypeformCreateContactRESTService is the public rest endpoint exposed via Public sites, so that typeform can send webhook requests.
* Created Date: 19-04-2019
*/

@RestResource(urlMapping='/CreateContactFromTypeform')
global class TypeformCreateContactRESTService {
    @HttpPost
    global static string CreateContactFromWebhookRequest() {
        string response = '';
        try
        {
            RestRequest request = RestContext.request;
            system.debug('REST Service CreateContactFromTypeform Called by typeform Webhook...');
            Blob body = request.requestBody;
            string payload = body.toString();
            
            system.debug('RequestBody: ' + payload);
            Logger.Log('Information', 'contact Data', 'CreateContactFromWebhookRequest', payload);
            //Input JSON contains reserved word 'number' which needs to be replaced before parsing as Wrapper does not allow reserved words.
            payload = payload.replace('\"number\"', '\"number_x\"');
            payload = payload.replace('\"date\"', '\"date_x\"');
            system.debug('RequestBody Corrected: ' + payload);
            
            TypeformWrapper.Response WebhookResponse = (TypeformWrapper.Response)System.JSON.deserialize(payload, TypeformWrapper.Response.class);
            system.debug('WebHook Response Deserialized: ' + WebhookResponse);            
            boolean bRet = TypeformUtilityClass.CreateContactFromResponse(WebhookResponse);
            if(bRet)
                response = 'Payload recieved successfully.';
            else
                response = 'Error while Creating Contact from Response.';
        }
        catch(Exception oEx)
        {
            Logger.Log('Error','Line Number: ' + oEx.getLineNumber() + ' Message: ' + oEx.getMessage() + 'Stack Trace: '+oEx.getStackTraceString(), 'TypeformCreateContactRESTService.CreateContactFromWebhookRequest', '');    
            system.debug('Error: ' + 'Line Number: ' + oEx.getLineNumber() + ' Message: ' + oEx.getMessage());
            response = 'Error occured.';
        }
        
        return response;
    }
}