/** Mock class for testing Http Callouts
 * Date : 22April 2019
**/
@isTest
public class HttpMockResponseTypeForm  implements HttpCalloutMock{
    public HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"id":"fNyeNI","title":"Spitalfields New Membership Form","fields":[{"id":"Nk1C2AHyFvxc","title":"Nice to meet you, what your first name?","ref":"d9e02bf6160abb3d","type":"short_text"},{"id":"rnUG9j7DCGFW","title":"Thank and your last name?","ref":"8e0092592834e47a","type":"short_text"},{"id":"Vjo3kSC4b9Ds","title":"What is your gender?","ref":"00f9c9f3-3e04-4c80-8e49-65ed1e3c3ee2","type":"multiple_choice"}]}');
        return response; 
    }
}