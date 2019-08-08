public class Veevatization_EventConfigurationHandler implements Queueable, Database.AllowsCallouts
{
    String EventConfigBody;
    String ParentSessionID;
    String EndPointURL;
    String ProdURL;
    public Veevatization_EventConfigurationHandler(String ParentSessionID, String ProdURL , String NewRecordsURL)
    {
        this.ParentSessionID = ParentSessionID;
        this.ProdURL = ProdURL;
        Boolean done = true;
        if(NewRecordsURL == NULL)
        {
            //this.EndpointURL = ProdURL+'/services/data/v44.0/query?q=SELECT+id,End_Date_vod__c,External_ID_vod__c,Event_Type_vod__c,Name,RecordTypeId,Start_Date_vod__c,+(+SELECT++country_Override_vod__c,External_id__c,Event_Configuration_vod__c,Event_Layout_vod__c,Event_Object_Name_vod__c,Event_Status_vod__c,Event_Team_Role_vod__c,Expense_Estimate_Layout_vod__c,Expense_Header_Layout_vod__c,Expense_Line_Layout_vod__c,Help_Text_vod__c,Name,Page_Layout_vod__c,RecordTypeId,Record_Type_vod__c,User_Profile_Id_vod__c,User_Profile_vod__c,Visible_Buttons_vod__c+FROM+EM_Event_Layout_vod__r),(SELECT+id,Country_vod__r.Alpha_2_Code_vod__c,+Event_Configuration_vod__c,External_ID_vod__c,RecordTypeId+FROM+Event_Configuration_Country_vod__r),(SELECT+Account_Attendee_Fields_vod__c,Contact_Attendee_Fields_vod__c,Event_Configuration_vod__c,External_ID_vod__c,Filter_Type_vod__c,Online_Registration_Fields_vod__c,Qualification_vod__c,RecordTypeId,Speaker_Fields_vod__c,User_Attendee_Fields_vod__c,Walk_In_Attendee_Statuses_vod__c,Walk_In_Fields_vod__c+FROM+Event_Rules__r),(SELECT+Allow_Comments_vod__c,Approver_Role_vod__c,Button_Name_vod__c,Confirmation_Message_vod__c,Ending_Status_vod__c,Entry_Criteria_Not_Met_Message_vod__c,Event_Configuration_vod__c,External_ID_vod__c,RecordTypeId,SFDC_Action_Type_vod__c,Starting_Status_vod__c+FROM+Event_Configuration_vod__r)+FROM+EM_Event_Configuration_vod__c+Where+End_date_vod__c+%3E+TODAY';
            this.EndpointURL = ProdURL+'/services/data/v44.0/query?q=SELECT+id,End_Date_vod__c,External_ID_vod__c,Event_Type_vod__c,Name,Start_Date_vod__c,+(+SELECT++country_Override_vod__c,External_id__c,Event_Configuration_vod__c,Event_Layout_vod__c,Event_Object_Name_vod__c,Event_Status_vod__c,Event_Team_Role_vod__c,Expense_Estimate_Layout_vod__c,Expense_Header_Layout_vod__c,Expense_Line_Layout_vod__c,Help_Text_vod__c,Name,Page_Layout_vod__c,RecordTypeId,Record_Type_vod__c,User_Profile_Id_vod__c,User_Profile_vod__c,Visible_Buttons_vod__c+FROM+EM_Event_Layout_vod__r),(SELECT+id,Country_vod__r.Alpha_2_Code_vod__c,+Event_Configuration_vod__c,External_ID_vod__c,RecordTypeId+FROM+Event_Configuration_Country_vod__r),(SELECT+Account_Attendee_Fields_vod__c,Contact_Attendee_Fields_vod__c,Event_Configuration_vod__c,External_ID_vod__c,Filter_Type_vod__c,Online_Registration_Fields_vod__c,Qualification_vod__c,RecordTypeId,Speaker_Fields_vod__c,User_Attendee_Fields_vod__c,Walk_In_Attendee_Statuses_vod__c,Walk_In_Fields_vod__c+FROM+Event_Rules__r),(SELECT+Allow_Comments_vod__c,Approver_Role_vod__c,Button_Name_vod__c,Confirmation_Message_vod__c,Ending_Status_vod__c,Entry_Criteria_Not_Met_Message_vod__c,Event_Configuration_vod__c,External_ID_vod__c,RecordTypeId,SFDC_Action_Type_vod__c,Starting_Status_vod__c+FROM+Event_Configuration_vod__r)+FROM+EM_Event_Configuration_vod__c+Where+End_date_vod__c+%3E+TODAY';
        }
        else
        {
            this.EndpointURL = ProdURL+NewRecordsURL;
        }
        
    }
    public void execute(QueueableContext context)
    {
        String NewRecordsLinkUrlLink;
        Boolean done = true;
        Integer totalRecordCount = 0;
        try
        {
            HTTPRequest req = new HTTPRequest();
            req.setEndpoint(EndpointURL);
            //System.debug('EndPointUrl is '+EndpointURL);
            req.setMethod('GET');
            req.setTimeout(60000);
            req.setHeader('Authorization','Bearer '+ParentSessionID);
            req.setHeader('Content-Type', 'application/json; charset=UTF-8');
            
            HTTPResponse response = new HTTP().send(req);
            //System.debug('Event Configuration Response Body '+response.getBody());
                   
            if(response.getStatusCode() == 200)
            {
                JSONParser parser = JSON.CreateParser(response.getBody());
                
                while(parser.nextToken() != NULL)
                {
                    if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME)
                    {
                        String text = parser.getText();
                        if (parser.nextToken() != System.JSONToken.VALUE_NULL)
                        {
                            if(text == 'totalSize')
                            {
                                totalRecordCount = parser.getIntegerValue();
                                //System.debug('Total Records returned '+parser.getIntegerValue());
                            }
                            else if(text == 'done')
                            {
                                done = parser.getBooleanValue();
                                //System.debug('done returned '+parser.getBooleanValue());
                            }
                            else if(text == 'nextRecordsUrl')
                            {
                                NewRecordsLinkUrlLink = parser.getText();
                                //System.debug('nextRecordsUrl is '+parser.getText());
                            }
                        }
                    }
                }
            }
            else
            {
                throw new CallOutException(response.getBody());
            }
            JSONParser EventConfigParser = JSON.createParser(response.getBody());
        
            String strInsertError = '';
            List<sObject> a  = new  List<sObject>();
            List<sObject> Em_layoutList = new list<sObject>();
            List<sObject> UpEm_layoutList = new list<sObject>();
            List<sObject> Em_countryList = new list<sObject>();
            List<sObject> UpEm_countryList = new list<sObject>();
            List<sObject> Em_ruleList = new list<sObject>();
            List<sObject> UpEm_ruleList = new list<sObject>();
            List<sObject> Em_actionList = new list<sObject>();
            List<sObject> UpEm_actionList = new list<sObject>();
            Map<String,sObject> CountryMap = new Map<String,sObject>();
            
            Type EMObjectType = Type.forName('EM_Event_Configuration_vod__c');
            while(EventConfigParser.nextToken() != NULL)
            {
                //Integer Count = 1;
                if(EventConfigParser.getCurrentToken() == JSONToken.Start_Array)
                {
                    while(EventConfigParser.nextToken() != NULL)
                    {
                        if(EventConfigParser.getCurrentToken() == JSONToken.Start_Object)
                        {
                            sObject em = (sObject)EventConfigParser.readValueAs(EMObjectType);
                            //system.debug('Record Type ID'+em.get('recordtypeid'));
                            //System.debug('End date'+em.get('End_Date_vod__c'));
                            List<sObject> EMLayoutTemp = new List<sObject>();
                            if(em.getSObjects('EM_Event_Layout_vod__r') != NULL)
                            {
                                EMLayoutTemp = em.getSObjects('EM_Event_Layout_vod__r');
                            }
                            //system.debug('Layout Size '+EMLayoutTemp.size());
                            List<sObject> EMCountryTemp = new List<sObject>();
                            if(em.getSObjects('Event_Configuration_Country_vod__r') != NULL)
                            {
                                EMCountryTemp = em.getSObjects('Event_Configuration_Country_vod__r');
                            }
                            //system.debug('Country Size'+EMCountryTemp.size());
                            //System.debug('Count check for null pointer exception '+count);
                            if(EMLayoutTemp.size() >0 && em.get('recordtypeid') != null && EMCountryTemp.size() > 0)
                            {
                                em.put('External_ID_vod__c', '');
                                em.put('External_ID_vod__c' , em.id);
                                em.put('id',NULL);
                                a.add(em);
                                //System.debug('entered');
                            
                                integer CounterInner1 = 1;                            
                                for(sObject eml : em.getSObjects('EM_Event_Layout_vod__r'))
                                {
                                    eml.put('External_ID__c' , '');
                                    eml.put('External_ID__c' , em.get('External_ID_vod__c')+'__'+CounterInner1);
                                    //eml.put('id', NULL);
                                    CounterInner1 = CounterInner1 + 1;
                                    Em_LayoutList.Add(eml);
                                }
                            
                                integer CounterInner2 = 1;
                                for(sObject emc : em.getSObjects('Event_Configuration_Country_vod__r'))
                                {
                                    
                                    emc.put('External_ID_vod__c' , em.get('External_ID_vod__c')+'__'+emc.get('id'));
                                    emc.put('id',NULL);
                                    CounterInner2 = CounterInner2 + 1;
                                    EM_CountryList.add(emc);
                                    //System.debug('Country Added');
                                }
                            
                                integer CounterInner3 = 1;
                                for(sObject emr : em.getSobjects('Event_Rules__r'))
                                {
                                    emr.put('External_ID_vod__c' , em.get('External_ID_vod__c')+'__'+CounterInner3);
                                    //emr.put('id',NULL);
                                    CounterInner3 = CounterInner3 + 1;
                                    EM_RuleList.add(emr);
                                }
                            
                                integer CounterInner4 = 1;
                                for(sObject ema : em.getSObjects('Event_Configuration_vod__r'))
                                {
                                    ema.put('External_ID_vod__c' , em.get('External_ID_vod__c')+'__'+CounterInner4);
                                    ema.put('id',NULL);
                                    CounterInner4 = CounterInner4 + 1;
                                    EM_ActionList.add(ema);
                                }
                            }
                            EventConfigParser.SkipChildren();
                        }
                        //Count = Count + 1;
                    }
                }
            }
        
            Map<string,sObject> EmLayoutMap = new Map<string,sObject>();
            for(sObject eml :Em_layoutList)
            {
                EmLayoutMap.put((String)eml.get('External_id__c'),eml);
            }
            map<string,sObject> EmCountryMap = new Map<string,sObject>();
            
            for(sObject emc :Em_countryList)
            {
                EmCountryMap.put((String)emc.get('External_id_vod__c'),emc);
            }
        
            map<string,sObject> EmActionMap = new Map<string,sObject>();
            
            for(sObject ema :Em_actionList)
            {
                EmActionMap.put((String)ema.get('External_id_vod__c'),ema);
            }
            
            map<string,sObject> EmRuleMap = new Map<string,sObject>();
        
            for(sObject emr :Em_ruleList)
            {
                EmRuleMap.put((String)emr.get('External_id_vod__c'),emr);
            }
            Database.SaveResult[] results = Database.insert(a,false);
            Integer count = 0;
            for(Integer i = 0; i < results.size(); i++)
            {
                if(results[i].isSuccess())
                {
                    count++;
                }
                else
                {
                    System.debug('Event Configuration Parent Failed due to '+results[i].getErrors());
                }
            }
            //System.debug(count+' Event Configuration Records Inserted');
            String EMQuery = 'select id, External_id_vod__c from EM_Event_Configuration_vod__c';
            Map<id,sObject>  EMMAp = new Map<id,sObject>(Database.Query(EMQuery));
            for (Integer i = 0; i < results.size(); i++) 
            {
                if (results[i].isSuccess()) 
                {
                    string identifier = (String)EMMAp.get(results[i].getId()).get('External_id_vod__c');
                    id EventCongfigID = results[i].getId();
                    for(sObject mapItem:  EmLayoutMap.values())
                    {
                        String temp = (String)mapItem.get('External_id__c');
                        if(temp.startswith(identifier))
                        {
                            mapItem.put('Event_Configuration_vod__c' , EventCongfigID);
                            UpEm_layoutList.add(mapItem);
                        }
                    }
                    for(sObject mapItem:  EmCountryMap.values())
                    {
                        String temp = (String)mapItem.get('External_id_vod__c');
                        if(temp.startswith(identifier))
                        {
                            mapItem.put('Event_Configuration_vod__c' , EventCongfigID);
                            UpEm_countryList.add(mapItem);
                        }
                    }
                    for(sObject mapItem:  EmRuleMap.values())
                    {
                        String temp = (String)mapItem.get('External_id_vod__c');
                        if(temp.startswith(identifier))
                        {
                            mapItem.put('Event_Configuration_vod__c' , EventCongfigID);
                            //if(mapItem.RecordType.DeveloperName != 'Material_vod')
                            //{
                                UpEm_ruleList.add(mapItem);
                            //}
                        }
                    }
                    for(sObject mapItem:  EmActionMap.values())
                    {
                        String temp = (String)mapItem.get('External_id_vod__c');
                        if(temp.startswith(identifier))
                        {
                            mapItem.put('Event_Configuration_vod__c' , EventCongfigID);
                            UpEm_actionList.add(mapItem);
                        }
                    }
                
                
                }
            }
            
            Database.SaveResult[] results2 = Database.insert(UpEm_countryList,false);
            String EMCQuery = 'select id, External_id_vod__c from EM_Event_Configuration_Country_vod__c';
            Map<id,sObject>  EMCMAp = new Map<id,sObject>(Database.Query(EMCQuery));
            for(Integer i = 0; i < results2.size(); i++)
            {
                if(results2[i].isSuccess())
                {
                    string identifier2 = (String)EMCMAp.get(results2[i].getId()).get('External_id_vod__c');
                    id EventConfigCountryID = results2[i].getId();
                    for(sObject sItem : UpEm_layoutList)
                    {
                        String sCountryId1 = (String)sItem.get('Country_Override_vod__c');
                        if(sCountryId1 != NULL)
                        {
                            if(identifier2.endsWith(sCountryID1))
                            {
                                sItem.put('Country_Override_vod__c', NULL);
                                sItem.put('Country_Override_vod__c',EventConfigCountryID);
                            }
                        }
                    }
                    
                    for(sObject sItem : UpEm_ruleList)
                    {
                        String sCountryId2 = (String)sItem.get('Country_Override_vod__c');
                        if(sCountryId2 != NULL)
                        {
                            if(identifier2.endsWith(sCountryID2))
                            {
                                sItem.put('Country_Override_vod__c', NULL);
                                sItem.put('Country_Override_vod__c',EventConfigCountryID);
                            }
                        }
                    }
                    
                    for(sObject sItem : UpEm_actionList)
                    {
                        String sCountryId3 = (String)sItem.get('Country_Override_vod__c');
                        if(sCountryId3 != NULL)
                        {
                            if(identifier2.endsWith(sCountryID3))
                            {
                                sItem.put('Country_Override_vod__c', NULL);
                                sItem.put('Country_Override_vod__c',EventConfigCountryID);
                            }
                        }
                    }
                }
                else
                {
                    System.debug('Event Configuration Country Failed due to '+results2[i].getErrors());
                }
            }
            //ProgressList.add(count+' Event Configuration Country Records Inserted');
        
            Database.SaveResult[] results1 = Database.insert(UpEm_layoutList,false);
            count = 0;
            for(Integer i = 0; i < results1.size(); i++)
            {
                if(results1[i].isSuccess())
                {
                    count++;
                }
                else
                {
                    System.debug('Failed due to '+results1[i].getErrors());
                    //System.debug('Failed record is '+UpEm_layoutList[i]);
                }
            }
            //ProgressList.add(count+' Event Layout Records Inserted');
        
            Database.SaveResult[] results3 = Database.insert(UpEm_ruleList,false);
            count = 0;
            for(Integer i = 0; i < results3.size(); i++)
            {
                if(results3[i].isSuccess())
                {
                    count++;
                }
                else
                {
                    System.debug('Event Rule Failed due to '+results3[i].getErrors());
                    //System.debug('Event Rule Failed due to '+UpEm_ruleList[i]);
                }
            }
            //ProgressList.add(count+' Event Rule Records Inserted');
        
            Database.SaveResult[] results4 = Database.insert(UpEm_actionList,false);
            count = 0;
            for(Integer i = 0; i < results4.size(); i++)
            {
                if(results4[i].isSuccess())
                {
                    count++;
                }
                else
                {
                    System.debug('Event Action Failed due to '+results4[i].getErrors());
                    //System.debug('Event Action Failed due to '+UpEm_actionList[i]);
                }   
            }
            //ProgressList.add(count+' Event Action Recordsed');
        
            if(NewRecordsLinkUrlLink != NULL)
            {
                System.debug('New Records URL Link is called again '+NewRecordsLinkUrlLink);
                System.enqueueJob(new Veevatization_EventConfigurationHandler(ParentSessionID,ProdURL, NewRecordsLinkUrlLink));
            }
        
        }
        catch(System.Exception e)
        {
            System.debug('Event Configuration fetch failed due to '+e);
        }
    }
}