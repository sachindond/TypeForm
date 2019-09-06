/** Test class for REST webservice
 * Created Date : 22 April 2019
 **/
@isTest
public class TestTypeformCreateContactRESTService {
    static testMethod void testTypeformCreateContactRESTService(){
        Test.startTest();
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/CreateContactFromTypeform'; 
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf('{"event_id":"01D95CF35PM4VZGQHCSY95H5Z6","event_type":"form_response","form_response":{"form_id":"fNyeNI","answers":[{"type":"text","text":"DemoFirstName","field":{"id":"AccountId","type":"short_text","ref":"d9e02bf6160abb3d"}},{"type":"text","text":"DemoLastName","field":{"id":"rnUG9j7DCGFW","type":"short_text","ref":"8e0092592834e47a"}},{"type":"choice","choice":{"label":"Male"},"field":{"id":"Vjo3kSC4b9Ds","type":"multiple_choice","ref":"00f9c9f3-3e04-4c80-8e49-65ed1e3c3ee2"}},{"type":"text","text":"British","field":{"id":"GTLzXxOHQ1U4","type":"short_text","ref":"a7a1a0c07f6beb3b"}},{"type":"text","text":"18/10","field":{"id":"Birthdate","type":"short_text","ref":"3e4ee83110421afc"}},{"type":"text","text":"ZMM Consultancy","field":{"id":"lqAjFZmDco0E","type":"short_text","ref":"4498c9f586bad627"}},{"type":"text","text":"Salesforce Consultant","field":{"id":"WvMjLdeoNUUr","type":"short_text","ref":"6e9cd358a6ef3daa"}},{"type":"email","email":"demoemail@demo.com","field":{"id":"ejN9F55XuCaP","type":"email","ref":"f622bec5-1b50-4b91-ab39-1257926f55fb"}},{"type":"number","number":9999999999,"field":{"id":"es1gCMjWUHeq","type":"number","ref":"ba55da8d5a82fe15"}},{"type":"choice","choice":{"label":"Mobile Phone Call"},"field":{"id":"dzCTa51mqcBo","type":"multiple_choice","ref":"7ed72ea50629fb0f"}},{"type":"choices","choices":{"labels":["Accountancy","App development","Artificial Intelligence","Branding"]},"field":{"id":"oV7r9xz9bgbJ","type":"multiple_choice","ref":"45ed7914-547f-4c5e-9580-1e3168ba61df"}},{"type":"text","text":"Demo Topics","field":{"id":"Gw0hiXJDZbhr","type":"short_text","ref":"34c51d4e-1d0c-499f-ad57-2ece20170845"}},{"type":"choices","choices":{"labels":["The Be Better programme (our educational programme)","The Wellness programme (yoga, meditation etc)","Making new friendships","Making new business connections"]},"field":{"id":"BISYE60MW3S8","type":"multiple_choice","ref":"94fb1dbd-a5a7-49f1-b3f5-a033790b76c7"}}]}}');
        RestContext.request = request;
        Form__c newForm = new Form__c();
        newForm.Typeform_ID__c = 'fNyeNI';
        newForm.Title__c = 'testTitle';
        insert newForm;
        
        Field__c newField = new Field__c();
        newField.Form__c =newForm.id;
        newField.Typeform_Field_Id__c = 'AccountId';
        newField.Title__c = 'testTitle';
        newField.Mapped_Contact_Field__c = 'AccountId';
        newField.Type__c = 'text'; 
      
        insert newField;
        
        Field__c newField1 = new Field__c();
        newField1.Form__c =newForm.id;
        newField1.Typeform_Field_Id__c = 'Email';
        newField1.Title__c = 'testTitle';
        newField1.Mapped_Contact_Field__c = 'Email';
        newField1.Type__c = 'email'; 
        insert newField1;
        
        Field__c newField2 = new Field__c();
        newField2.Form__c =newForm.id;
        newField2.Typeform_Field_Id__c = 'number';
        newField2.Title__c = 'testTitle';
        newField2.Mapped_Contact_Field__c = 'BirthDate';
        newField2.Type__c = 'MobilePhone'; 
        insert newField2;
        
       
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'test@mytest.com.uat.test',
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
           
        );
        insert u;
        
        Typeform_Settings__c setting = new Typeform_Settings__c();
        setting.Name = 'Typeform Settings';
        setting.Access_Token__c = 'demo token';
        setting.Base_URL__c = 'https://test.com';
        setting.Contact_Owner_User_Name__c= 'test@mytest.com.uat.test';
        insert setting;
        
        
        Account a = new Account();
        a.Name = 'DemoFirstName';
        a.Finance_Contact_Email__c = 'test@gmail.com';
        a.customer_type__c = 'Community';
        a.Site__c = 'Hollywood';
        
        insert a;
        Account a1 = new Account();
        a1.Name = 'DemoFirstName1';
        a1.Finance_Contact_Email__c = 'test@gmail.com';
        a1.customer_type__c = 'Community';
        a1.Site__c = 'Spitalfields';
        insert a1;
        
        Account a2 = new Account();
        a2.Name = 'DemoFirstName11';
        a2.Finance_Contact_Email__c = 'test@gmail.com';
        a2.customer_type__c = 'Community';
        a2.Site__c = 'London Fields';
        insert a2;
        
        Account a3 = new Account();
        a3.Name = 'DemoFirstName12';
        a3.Finance_Contact_Email__c = 'test@gmail.com';
        a.customer_type__c = 'Community';
        a3.Site__c = 'Lisbon';
        insert a3;
        
        Account a4 = new Account();
        a4.Name = 'DemoFirstName21';
        a4.Finance_Contact_Email__c = 'test@gmail.com';
        a4.customer_type__c = 'Community';
        a4.Site__c = 'Holland Park';
        insert a4;
        
        Membership_Allocations__c ma = new Membership_Allocations__c();
        ma.Name='USA Community Membership';
        insert ma;
        
       
        
        
        string returnResult = TypeformCreateContactRESTService.CreateContactFromWebhookRequest();
        system.debug('** return result'+returnResult);
        Test.stopTest();  
    }
        static testMethod void testTypeformCreateContactRESTServiceForOtherAccount(){
        Test.startTest();
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/CreateContactFromTypeform'; 
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf('{"event_id":"01D95CF35PM4VZGQHCSY95H5Z6","event_type":"form_response","form_response":{"form_id":"fNyeNI","answers":[{"type":"text","text":"DemoFirstName","field":{"id":"AccountId","type":"short_text","ref":"d9e02bf6160abb3d"}},{"type":"text","text":"DemoLastName","field":{"id":"rnUG9j7DCGFW","type":"short_text","ref":"8e0092592834e47a"}},{"type":"choice","choice":{"label":"Male"},"field":{"id":"Vjo3kSC4b9Ds","type":"multiple_choice","ref":"00f9c9f3-3e04-4c80-8e49-65ed1e3c3ee2"}},{"type":"text","text":"British","field":{"id":"GTLzXxOHQ1U4","type":"short_text","ref":"a7a1a0c07f6beb3b"}},{"type":"text","text":"18/10","field":{"id":"Birthdate","type":"short_text","ref":"3e4ee83110421afc"}},{"type":"text","text":"ZMM Consultancy","field":{"id":"lqAjFZmDco0E","type":"short_text","ref":"4498c9f586bad627"}},{"type":"text","text":"Salesforce Consultant","field":{"id":"WvMjLdeoNUUr","type":"short_text","ref":"6e9cd358a6ef3daa"}},{"type":"email","email":"demoemail@demo.com","field":{"id":"ejN9F55XuCaP","type":"email","ref":"f622bec5-1b50-4b91-ab39-1257926f55fb"}},{"type":"number","number":9999999999,"field":{"id":"es1gCMjWUHeq","type":"number","ref":"ba55da8d5a82fe15"}},{"type":"choice","choice":{"label":"Mobile Phone Call"},"field":{"id":"dzCTa51mqcBo","type":"multiple_choice","ref":"7ed72ea50629fb0f"}},{"type":"choices","choices":{"labels":["Accountancy","App development","Artificial Intelligence","Branding"]},"field":{"id":"oV7r9xz9bgbJ","type":"multiple_choice","ref":"45ed7914-547f-4c5e-9580-1e3168ba61df"}},{"type":"text","text":"Demo Topics","field":{"id":"Gw0hiXJDZbhr","type":"short_text","ref":"34c51d4e-1d0c-499f-ad57-2ece20170845"}},{"type":"choices","choices":{"labels":["The Be Better programme (our educational programme)","The Wellness programme (yoga, meditation etc)","Making new friendships","Making new business connections"]},"field":{"id":"BISYE60MW3S8","type":"multiple_choice","ref":"94fb1dbd-a5a7-49f1-b3f5-a033790b76c7"}}]}}');
        RestContext.request = request;
        Form__c newForm = new Form__c();
        newForm.Typeform_ID__c = 'fNyeNI';
        newForm.Title__c = 'testTitle';
        insert newForm;
        
        Field__c newField = new Field__c();
        newField.Form__c =newForm.id;
        newField.Typeform_Field_Id__c = 'AccountId';
        newField.Title__c = 'testTitle';
        newField.Mapped_Contact_Field__c = 'AccountId';
        newField.Type__c = 'text'; 
      
        insert newField;
        
        Field__c newField1 = new Field__c();
        newField1.Form__c =newForm.id;
        newField1.Typeform_Field_Id__c = 'Email';
        newField1.Title__c = 'testTitle';
        newField1.Mapped_Contact_Field__c = 'Email';
        newField1.Type__c = 'email'; 
        insert newField1;
        
        Field__c newField2 = new Field__c();
        newField2.Form__c =newForm.id;
        newField2.Typeform_Field_Id__c = 'number';
        newField2.Title__c = 'testTitle';
        newField2.Mapped_Contact_Field__c = 'BirthDate';
        newField2.Type__c = 'MobilePhone'; 
        insert newField2;
        
       
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'test@mytest.com.uat.test',
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
           
        );
        insert u;
        
        Typeform_Settings__c setting = new Typeform_Settings__c();
        setting.Name = 'Typeform Settings';
        setting.Access_Token__c = 'demo token';
        setting.Base_URL__c = 'https://test.com';
        setting.Contact_Owner_User_Name__c= 'test@mytest.com.uat.test';
        insert setting;
        
        
        Account a = new Account();
        a.Name = 'DemoFirstName';
        a.Finance_Contact_Email__c = 'test@gmail.com';
        a.customer_type__c = 'Potential';
        a.Site__c = 'Hollywood';
        
        insert a;
        Account a1 = new Account();
        a1.Name = 'DemoFirstName1';
        a1.Finance_Contact_Email__c = 'test@gmail.com';
        a1.customer_type__c = 'Potential';
        a1.Site__c = 'Spitalfields';
        insert a1;
        
        Account a2 = new Account();
        a2.Name = 'DemoFirstName11';
        a2.Finance_Contact_Email__c = 'test@gmail.com';
        a2.customer_type__c = 'Potential';
        a2.Site__c = 'London Fields';
        insert a2;
        
        Account a3 = new Account();
        a3.Name = 'DemoFirstName12';
        a3.Finance_Contact_Email__c = 'test@gmail.com';
        a.customer_type__c = 'Potential';
        a3.Site__c = 'Lisbon';
        insert a3;
        
        Account a4 = new Account();
        a4.Name = 'DemoFirstName21';
        a4.Finance_Contact_Email__c = 'test@gmail.com';
        a4.customer_type__c = 'Potential';
        a4.Site__c = 'Holland Park';
        insert a4;
        
       
        
        
        string returnResult = TypeformCreateContactRESTService.CreateContactFromWebhookRequest();
        system.debug('** return result'+returnResult);
        Test.stopTest();  
    }
}