/** Class is  to Test Batch Class : TypeformBatchGetFormDetails
 *  Date : 22 April 2019
**/
@isTest
public class TestTypeformBatchGetFormDetails {
    
    
    
    static testMethod void testTypeformBatchGetFormDetails(){
        
        Typeform_Settings__c setting = new Typeform_Settings__c();
        setting.Name = 'Typeform Settings';
        setting.Access_Token__c = 'demo token';
        setting.Base_URL__c = 'https://test.com';
        insert setting;
        
        Account accountObj = new Account();
        accountObj.Name = 'test name';
        accountObj.Finance_Contact_Email__c = 'test@gmail.com';
        insert accountObj;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpMockResponseTypeForm());
        TypeformBatchGetFormDetails typeformBatchObject = new TypeformBatchGetFormDetails();
        database.executeBatch(typeformBatchObject);
        test.stopTest();
    }
    static testMethod void testLoggerException(){
        
        Typeform_Settings__c setting = new Typeform_Settings__c();
        setting.Name = 'Typeform Settings';
        setting.Access_Token__c = 'demo token';
        setting.Base_URL__c = null;
        insert setting;
        
        Account accountObj = new Account();
        accountObj.Name = 'test name';
        accountObj.Finance_Contact_Email__c = 'test@gmail.com';
        insert accountObj;
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpMockResponseTypeForm());
        TypeformBatchGetFormDetails typeformBatchObject = new TypeformBatchGetFormDetails();
        database.executeBatch(typeformBatchObject);
        test.stopTest();
    }
    
}