public class Veevatization_Helper {
    
    //List to Store Included Components
    Public List<String> IncludedFixedComponents {get;set;}
    Public List<String> IncludedDynamicComponents {get;set;}
    Public List<String> FixedComponentHelpTextList {get; set;}
    Public List<wrapComponents> IncludedFixedWrappedComponents {get;set;}
    Public List<wrapComponents> IncludedDynamicWrappedComponents {get;set;}
    
    
    Public Boolean enableActionPoller {get; set;}
    
    Public List<String> ProgressList {get; set;}
    Public List<String> SelectedObjects {get; set;}
    
    Public String SelectedObjectsJSONHelper {get; set;}
    Public String JSONToRequest {get; set;}
    
    Public String SessionID {get; set;}
    
    Public String ProdURL = System.Label.Production_ORG_URL_Veevatization;
    
    public Veevatization_Helper()
    {
       enableActionPoller = false;
       IncludedFixedComponents = new List<String>();
       IncludedDynamicComponents = new List<String>();
       FixedComponentHelpTextList = new List<String>();
       String IncludedFixedLabel = 'Country_vod__c;EM_Event_Configuration_vod__c;Product_vod__c;Product_Group_vod__c;Metric_Configuration_vod__c';
       String IncludedDynamicLabel = Label.Included_Objects;
       String FixedComponentHelpText = '   --   Please import Country_vod__c before importing EM_Event_Configuration_vod__c;   --   Please import Product_vod__c before importing Product_Group_vod__c;   --   Please import Product_vod__c and Product_Group_vod__c before importing Metric_Configuration_vod__c';
       IncludedFixedComponents = IncludedFixedLabel.split(';');
       IncludedDynamicComponents = IncludedDynamicLabel.split(';');
       FixedComponentHelpTextList = FixedComponentHelpText.split(';');
       ProgressList = new List<String>();
       SessionID = LoginSalesforceProd.login();
       if(IncludedFixedComponents.size()>0)
       {
           if(IncludedFixedWrappedComponents == null)
           {
               IncludedFixedWrappedComponents = new List<wrapComponents>();
           }
           else
           {
               IncludedFixedWrappedComponents.clear();
           }
           for(String tempString : IncludedFixedComponents)
           {
               If(tempString == 'EM_Event_Configuration_vod__c')
                   {
                       IncludedFixedWrappedComponents.add(new wrapComponents(tempString, FixedComponentHelpTextList[0], false, false));
                   }
               else if(tempString == 'Product_Group_vod__c')
                   {
                       IncludedFixedWrappedComponents.add(new wrapComponents(tempString, FixedComponentHelpTextList[1], false, false));
                   }
               else if(tempString == 'Metric_Configuration_vod__c')
                   {
                       IncludedFixedWrappedComponents.add(new wrapComponents(tempString, FixedComponentHelpTextList[2], false, false));
                   }
               else
                   {
                       IncludedFixedWrappedComponents.add(new wrapComponents(tempString, null, false, false));
                   }
           }
       }
       if(IncludedDynamicComponents.size()>0)
       {
           if(IncludedDynamicWrappedComponents == null)
           {
               IncludedDynamicWrappedComponents = new List<wrapComponents>();
           }
           else
           {
               IncludedDynamicWrappedComponents.clear();
           }
           for(String tempString : IncludedDynamicComponents)
           {
               IncludedDynamicWrappedComponents.add(new wrapComponents(tempString, null, false, false));
           }
       }
    }
    Public void DeleteRecords()
    {
        enableActionPoller = true;
        if(ProgressList == null)
        {
            ProgressList = new List<String>();
        }
        else
        {
            ProgressList.clear();
        }
        if(SelectedObjects == null)
        {
            SelectedObjects = new List<String>();
        }
        else
        {
            SelectedObjects.clear();
        }
        if(SelectedObjectsJSONHelper != null)
        {
            SelectedObjectsJSONHelper = '';
        }
        for(wrapComponents w : IncludedFixedWrappedComponents)
        {
            if(w.selected == true)
            {
                SelectedObjects.add(w.ComponentName);
            }
        }
        for(wrapComponents w : IncludedDynamicWrappedComponents)
        {
            if(w.selected == true)
            {
                SelectedObjects.add(w.ComponentName);
            }
        }
        if(SelectedObjects.size()>0)
        {
            
            for(String s : SelectedObjects)
            {
                if(s == 'EM_Event_Configuration_vod__c')
                {
                    System.enqueueJob(new QueueDelete('EM_Event_Layout_vod__c'));
                    System.enqueueJob(new QueueDelete('EM_Event_Action_vod__c'));
                    System.enqueueJob(new QueueDelete('EM_Event_Rule_vod__c'));
                    System.enqueueJob(new QueueDelete('EM_Event_Configuration_Country_vod__c'));
                    System.enqueueJob(new QueueDelete('EM_Event_Configuration_vod__c'));
                }
                else
                {
                    System.enqueueJob(new QueueDelete(s));
                }
            }
            JSONToRequest = 'Delete Request for '+SelectedObjects.size()+' Object(s) submitted';
            ProgressList.add(JSONToRequest);
        }
        else
        {
            ProgressList.Add('No Components Selected');
        }
        enableActionPoller = false;
    }
    Public void ImportRecords()
    {
        enableActionPoller = true;
        if(ProgressList == null)
        {
            ProgressList = new List<String>();
        }
        else
        {
            ProgressList.clear();
        }
        if(SelectedObjects == null)
        {
            SelectedObjects = new List<String>();
        }
        else
        {
            SelectedObjects.clear();
        }
        if(SelectedObjectsJSONHelper != null)
        {
            SelectedObjectsJSONHelper = '';
        }
        for(wrapComponents w : IncludedFixedWrappedComponents)
        {
            if(w.selected == true)
            {
                SelectedObjects.add(w.ComponentName);
            }
        }
        for(wrapComponents w : IncludedDynamicWrappedComponents)
        {
            if(w.selected == true)
            {
                SelectedObjects.add(w.ComponentName);
            }
        }
        if(SelectedObjects.size()>0)
        {
            
            for(String s : SelectedObjects)
            {
                if(s != null)
                {
                    if(SelectedObjectsJSONHelper == '' || SelectedObjectsJSONHelper == null)
                    {
                        SelectedObjectsJSONHelper = s;
                    }
                    else
                    {
                        SelectedObjectsJSONHelper = SelectedObjectsJSONHelper + ';' + s;
                    }
                }
            }
            JSONToRequest = SelectedObjects.size()+' Object(s) selected';
            ProgressList.add(JSONToRequest);
            FetchRecordsfromParentORG(SelectedObjectsJSONHelper);
        }
        else
        {
            ProgressList.Add('No Components Selected');
        }
        enableActionPoller = false;
    }
    Public class wrapComponents
    {
        public Boolean selected {get; set;}
        public Boolean disabledCheckbox {get; set;}
        public String ComponentName {get; set;}
        public String HelpText {get; set;}
        public wrapComponents(String varComponent, String varHelpText, Boolean varSelected, Boolean varDisabled)
        {
            ComponentName = varComponent;
            HelpText = varHelpText;
            selected = varSelected;
            disabledCheckbox = varDisabled;
        }
    }
    Public void DeleteExistingRecordsFunction(String ObjectNameHelper)
    {
        String query = '';
        try
        {
            
            batchDeleteRecords del = new batchDeleteRecords(ObjectNameHelper);
            database.executeBatch(del,1000);
            system.debug('Batch Job Called');
        }
        catch(Exception e)
        {
            ProgressList.add('Deletion of records from '+ObjectNameHelper+' failed due to '+e);
        }
    }
    Public void FetchRecordsfromParentORG(String ObjectListHelper)
    {
        try
        {
            String[] ObjectsList = ObjectListHelper.split(';');
            for(String s : ObjectsList)
            {
                if(s == 'EM_Event_Configuration_vod__c')
                {
                    ProgressList.Add('A request has been submitted for fetching Event Configuration. Please check Apex Jobs for progress.');
                    System.enqueueJob(new Veevatization_EventConfigurationHandler(SessionID, ProdURL, NULL));
                }
                else if(s == 'Product_vod__c')
                {
                    ProgressList.Add('A request has been submitted for fetching Products. Please check Apex Jobs for progress.');
                    System.enqueueJob(new Veevatization_ProductHandler(SessionID, ProdURL, NULL));
                }
                else if(s == 'Product_Group_vod__c')
                {
                    ProgressList.Add('A request has been submitted for fetching Product Groups. Please check Apex Jobs for progress.');
                    System.enqueueJob(new Veevatization_ProductGroupHandler(SessionID, ProdURL, NULL));
                }
                else if(s == 'Metric_Configuration_vod__c')
                {
                    ProgressList.Add('A request has been submitted for fetching Metric Configuration. Please check Apex Jobs for progress.');
                    System.enqueueJob(new Veevatization_MetricConfigurationHandler(SessionID, ProdURL, NULL));
                }
                else if(s != NULL)
                {
                    System.enqueueJob(new QueueImport(s,SessionID,null, ProdURL));
                    ProgressList.Add('A request has been submitted for fetching '+s+'. Please check Apex Jobs for progress.');
                }
            }
        }
        catch(Exception e)
        {
            ProgressList.Add('Driver Method failed due to '+e);
        }
    }    
}