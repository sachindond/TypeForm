/* Class Name: TypeformWrapper
* Wrapper Chasses to hold data received from Typeform API - Form and Fields
* Created Date: 16-04-2019
*/
public class TypeformWrapper {
	public string id;
    public string title;
    public List<Field> fields;
    
    public class Field
    {
        public string id;
        public string title;
        public string ref;
        public string type;
    }
    
    public class Response
    {
        public string event_id;
        public string event_type;
        public FormResponse form_response;
    }
    
    public class FormResponse
    {
        public string form_id;
        public List<Answer> answers;
    }
    
    public class Answer
    {
        public string type;
        public string text;
        public string email;
        public string number_x; //Actual JSON has number which is a reserved word. String replace is used before parsing JSON.
        public string file_url;
        public Field field;
        public Choice choice;
        public Choices choices;
        public string date_x;
    }
    
    public class Choice
    {
        public string label;
    }
    
    public class Choices
    {
        public List<string> labels;
    }
}