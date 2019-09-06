/* Class Name: TypeformUtilityClass
* Utility class has generic controller methods that will be utilised across batches and actions in future.
* Created Date: 16-04-2019
*/
public class TypeformUtilityClass {
    
    public static boolean CreateSingleFormAndFields(string typeformId)
    {
        boolean bRet = false;
        try
        {
            //Get From details from Typeform API and create Form and Fields in SFDC
            TypeformWrapper ReturnedData = TypeformHTTPCallouts.GetSingleFormDetails(typeformId);
            //Create form
            Form__c newForm = new Form__c();
            newForm.Typeform_ID__c = ReturnedData.id;
            newForm.Title__c = ReturnedData.title;
            upsert newForm Typeform_ID__c;
            //Create Fields
            List<Field__c> fieldslist = new List<Field__c>();
            For(TypeformWrapper.Field currentField: ReturnedData.fields)
            {
                Field__c newField = new Field__c();
                newField.Form__c = newForm.Id;
                newField.Typeform_Field_Id__c = currentField.id;
                newField.Title__c = currentField.title;
                newField.Reference__c = currentField.ref;
                newField.Type__c = currentField.type; 
                fieldslist.add(newField);
            }
            
            if(fieldslist.size() > 0)
                upsert fieldslist Typeform_Field_Id__c;
            
            return true;
        }
        catch(Exception oEx)
        {
            Logger.Log('Error','Line Number: ' + oEx.getLineNumber() + ' Message: ' + oEx.getMessage(), 'TypeformUtilityClass.CreateSingleFormAndFields', '');    
            system.debug('Error: ' + 'Line Number: ' + oEx.getLineNumber() + ' Message: ' + oEx.getMessage());
            bRet = false;
        }
        return bRet;
    }   
    
    
    public static boolean CreateContactFromResponse(TypeformWrapper.Response WebhookResponse)
    {
        boolean bRet = false;
        try
        {
            //Get Form Id in Scope
            string formid = WebhookResponse.form_response.form_id;
            //Get Field Mappings from SFDC Form and Fields Records, Create the contact based on the values
            List<Form__c> CurrentFormWithFields = [Select Id, Typeform_ID__c, (SELECT Id, Typeform_Field_Id__c, Mapped_Contact_Field__c 
                                                                               FROM Fields__r WHERE Mapped_Contact_Field__c != NULL)
                                                   FROM Form__c
                                                   WHERE Typeform_ID__c =: formid LIMIT 1];
            
            if(CurrentFormWithFields != null && CurrentFormWithFields.size() > 0) //Valid Form Record Received
            {
                Map<string, string> FieldIdToContactIdMap = new Map<string, string>();
                For(Field__c currentField : CurrentFormWithFields[0].Fields__r)
                {
                    FieldIdToContactIdMap.put(currentField.Typeform_Field_Id__c, currentField.Mapped_Contact_Field__c);
                }
                system.debug('FieldIdToContactIdMap Found Fields with Mapping Count: ' + FieldIdToContactIdMap);
                String accountName = '';
                Contact newcontact = new Contact();
                Logger.Log('Info',JSON.serialize(FieldIdToContactIdMap), '', '');  
                For(TypeformWrapper.Answer currentAnswer: WebhookResponse.form_response.answers)
                {
                    if(FieldIdToContactIdMap.containsKey(currentAnswer.field.id))
                    {
                        system.debug('**current answer**'+currentAnswer.field.id);
                        if(currentAnswer.type == 'text')
                        {
                            system.debug('*** current AnswerText'+FieldIdToContactIdMap.get(currentAnswer.field.id));
                            if(FieldIdToContactIdMap.get(currentAnswer.field.id) == 'AccountId')
                                accountName = currentAnswer.text;
                            /* Commented this out as we now map birthday to seperate Text field BirthDateTextEntry__c.
                            else if (FieldIdToContactIdMap.get(currentAnswer.field.id) == 'Birthdate')
                            {
                                
                                if(formid == 'fNyeNI')
                                	newcontact.put(FieldIdToContactIdMap.get(currentAnswer.field.id), Date.parse(currentAnswer.text + '/2019'));
                                else
                                {
                                    Logger.Log('Info','Inside Birthdate Else ', '', '');  
                                    newcontact.put(FieldIdToContactIdMap.get(currentAnswer.field.id), currentAnswer.text);

                                }
                            }
                              */  
                            else
                                newcontact.put(FieldIdToContactIdMap.get(currentAnswer.field.id), currentAnswer.text);

                        }
                        if(currentAnswer.type == 'email')
                            newcontact.put(FieldIdToContactIdMap.get(currentAnswer.field.id), currentAnswer.email);
                        if(currentAnswer.type == 'number_x')
                            newcontact.put(FieldIdToContactIdMap.get(currentAnswer.field.id), currentAnswer.number_x);
                        if(currentAnswer.type == 'file_url')
                            newcontact.put(FieldIdToContactIdMap.get(currentAnswer.field.id), currentAnswer.file_url);
                        if(currentAnswer.type == 'choice')
                            newcontact.put(FieldIdToContactIdMap.get(currentAnswer.field.id), currentAnswer.choice.label);
                        if(currentAnswer.type == 'choices') //TODO: need string manipulation here
                        {
                            string choices = '';
                            for(string current: currentAnswer.choices.labels)
                                choices = choices + current + ';';
                            choices = choices.substring(0, choices.length() -1);
                            system.debug('choices: ' + choices);
                            newcontact.put(FieldIdToContactIdMap.get(currentAnswer.field.id), choices);
                        }     
                        if(currentAnswer.type == 'date_x') //TODO: need string manipulation here
                            newcontact.put(FieldIdToContactIdMap.get(currentAnswer.field.id), currentAnswer.date_x);
                    }
                }
                
                //Set other fields as per the defined rules.
                if(accountName != '')
                {
                    List<Account> currentAccount = [SELECT Id, Name, Site__c, customer_type__c, RecordType.Name From Account Where Name =:accountName];
                    if(currentAccount != null && currentAccount.size() > 0)
                    {
                        newcontact.AccountId = currentAccount[0].Id;
                        Id RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(currentAccount[0].RecordType.Name).getRecordTypeId();
                        if(RecordTypeId != null)
                        {
                            newContact.RecordTypeId = RecordTypeId;
                            newContact.Member_Type__c = currentAccount[0].RecordType.Name;
                        }
                        newContact.Site__c = currentAccount[0].Site__c;
                        
                        //Set Membership Allocation
                        List<Membership_Allocations__c> membershipAllocationsList = [Select Id, Name From Membership_Allocations__c];
                        Map<String, Id> MembershipNameToIdMap = new Map<String, Id>();
                        For(Membership_Allocations__c currentAllocation: membershipAllocationsList)
                            MembershipNameToIdMap.put(currentAllocation.Name, currentAllocation.Id);
                        
                        if(currentAccount[0].customer_type__c == 'Community')
                        {
                            if(currentAccount[0].Site__c == 'Hollywood')
                                newContact.Membership_Allocations__c = MembershipNameToIdMap.get('USA Community Membership');
							if(currentAccount[0].Site__c == 'Spitalfields')
                                newContact.Membership_Allocations__c = MembershipNameToIdMap.get('Spitalfields Community Membership');
                            if(currentAccount[0].Site__c == 'London Fields')
                                newContact.Membership_Allocations__c = MembershipNameToIdMap.get('London Fields Community Membership');
							if(currentAccount[0].Site__c == 'Lisbon')
                                newContact.Membership_Allocations__c = MembershipNameToIdMap.get('Lisbon Community Membership');
							if(currentAccount[0].Site__c == 'Holland Park')
                                newContact.Membership_Allocations__c = MembershipNameToIdMap.get('Holland Park Community Membership');
                            if(currentAccount[0].Site__c == 'Clerkenwell Green')
                                newContact.Membership_Allocations__c = MembershipNameToIdMap.get('Clerkenwell Green Community Membership');
                            if(currentAccount[0].Site__c == 'Dalston')
                                newContact.Membership_Allocations__c = MembershipNameToIdMap.get('Dalston Community Membership');
                            if(currentAccount[0].Site__c == 'Ladbroke Grove')
                                newContact.Membership_Allocations__c = MembershipNameToIdMap.get('Ladbroke Grove Community Membership');
                            if(currentAccount[0].Site__c == 'London-wide')
                                newContact.Membership_Allocations__c = MembershipNameToIdMap.get('London-wide Community Membership');
                        }
                        else
                        {
                            if(currentAccount[0].Site__c == 'Hollywood')
                                newContact.Membership_Allocations__c = MembershipNameToIdMap.get('USA Standard Membership');
							if(currentAccount[0].Site__c == 'Spitalfields')
                                newContact.Membership_Allocations__c = MembershipNameToIdMap.get('Spitalfields Standard Membership');
							if(currentAccount[0].Site__c == 'London Fields')
                                newContact.Membership_Allocations__c = MembershipNameToIdMap.get('London Fields Standard Membership');
							if(currentAccount[0].Site__c == 'Lisbon')
                                newContact.Membership_Allocations__c = MembershipNameToIdMap.get('Lisbon Standard Membership');
							if(currentAccount[0].Site__c == 'Holland Park')
                                newContact.Membership_Allocations__c = MembershipNameToIdMap.get('Holland Park Standard Membership');
							if(currentAccount[0].Site__c == 'Clerkenwell Green')
                                newContact.Membership_Allocations__c = MembershipNameToIdMap.get('Clerkenwell Green Standard Membership');   
                            if(currentAccount[0].Site__c == 'Dalston')
                                newContact.Membership_Allocations__c = MembershipNameToIdMap.get('Dalston Standard Membership');
                            if(currentAccount[0].Site__c == 'Ladbroke Grove')
                                newContact.Membership_Allocations__c = MembershipNameToIdMap.get('Ladbroke Grove Standard Membership');
                            if(currentAccount[0].Site__c == 'London-wide')
                                newContact.Membership_Allocations__c = MembershipNameToIdMap.get('London-wide Standard Membership');
                        }                            
                    }
                }
                
                newContact.Relationship__c = 'Member';
                newContact.Membership_start_date__c = Date.today();
          
                // Logic Modified -1/9/2019 : We created new typeform setting to store form id and its conrrenspoding owner user name
                List<Typeform_Assign_Owner_To_Contact__c> lstOfTypeformUsers = Typeform_Assign_Owner_To_Contact__c.getAll().values();
                List<User> lstOfUser = new List<User>();
                Map<string,string> mapOfFormIdContactOwner = new Map<string,string>();
                string ownerUserName;
                for(Typeform_Assign_Owner_To_Contact__c typeFormObj :lstOfTypeformUsers){
                    mapOfFormIdContactOwner.put(typeFormObj.Form_Id__c,typeFormObj.Contact_Owner_Name__c);
                }
                // checking form id with map and assign username to contact
                /*
                if(formid=='fNyeNI')
                {
                    ownerUserName = mapOfFormIdContactOwner.get('fNyeNI');
                }else{
                    ownerUserName = mapOfFormIdContactOwner.get('kdibX7');
                }
				*/
                ownerUserName = mapOfFormIdContactOwner.get(formid);
                
                if(ownerUserName!=null){
                    lstOfUser = [select id from User Where UserName=:ownerUserName];
                    system.debug('****lst Of Users'+lstOfUser);
                }
                if(lstOfUser.size()>0){
                    newcontact.OwnerId = lstOfUser[0].Id;
                }
                //Insert the new contact
                //insert newcontact;
                upsert newcontact email;
                bRet = true;
            }
        }
        catch(Exception oEx)
        {
            Logger.Log('Error','Line Number: ' + oEx.getLineNumber() + ' Message: ', 'TypeformUtilityClass.CreateContactFromResponse Event Id: ' + WebhookResponse.event_id,
                       oEx.getStackTraceString() + oEx.getMessage());    
            system.debug('Error: ' + 'Line Number: ' + oEx.getLineNumber() + ' Message: ' + oEx.getMessage());
            bRet = false;           
        }
        return bRet;
    }
}