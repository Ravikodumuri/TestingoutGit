public class Veevatization_Helper_Ankita {
    
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
    
    public Veevatization_Helper_Ankita()
    {
       enableActionPoller = false;
       IncludedFixedComponents = new List<String>();
       IncludedDynamicComponents = new List<String>();
       FixedComponentHelpTextList = new List<String>();
       String IncludedFixedLabel = 'Country_vod__c;EM_Event_Configuration_vod__c;Product_vod__c;Product_Group_vod__c;Metric_Configuration_vod__c';
       String IncludedDynamicLabel = Label.Included_Objects;
       String FixedComponentHelpText = '   --   Please select Country_vod__c before selecting EM_Event_Configuration_vod__c;   --   Please select Product_vod__c before selecting Product_Group_vod__c;   --   Please select Product_vod__c and Product_Group_vod__c before selecting Metric_Configuration_vod__c';
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
                    DeleteExistingRecordsFunction('EM_Event_Layout_vod__c');
                    DeleteExistingRecordsFunction('EM_Event_Action_vod__c');
                    DeleteExistingRecordsFunction('EM_Event_Rule_vod__c');
                    DeleteExistingRecordsFunction('EM_Event_Configuration_Country_vod__c');
                    DeleteExistingRecordsFunction('EM_Event_Configuration_vod__c');
                    DeleteExistingRecordsFunction('Country_vod__c');
                }
                else if(s == 'Country_vod__c' && !s.Contains('EM_Event_Configuration_vod__c'))
                {
                    DeleteExistingRecordsFunction('Country_vod__c');
                }
                else if(s != 'Country_vod__c' || s != 'EM_Event_Configuration_vod__c')
                {
                    DeleteExistingRecordsFunction(s);
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
    Public void checkSelectedComponents()
    {
        /*for(wrapComponents w1 : IncludedWrappedComponents)
        {
            if(w1.ComponentName == 'EM_Event_Configuration_vod__c' || w1.ComponentName == 'Metric_Configuration_vod__c' || w1.ComponentName == 'Product_Group_vod__c')
            {
                for(wrapComponents w2 : IncludedWrappedComponents)
                {
                    if(w1.ComponentName == 'EM_Event_Configuration_vod__c' && w2.ComponentName == 'Country_vod__c')
                    {
                        if(w1.Selected)
                        {
                            w2.Selected = true;
                            w2.disabledCheckbox = true;
                        }
                        else
                        {
                            w2.disabledCheckbox = false;
                        }
                    }
                    else if(w1.ComponentName == 'Product_Group_vod__c' && w2.ComponentName == 'Product_vod__c')
                    {
                        if(w1.Selected)
                        {
                            w2.Selected = true;
                            w2.disabledCheckbox = true;
                        }
                        else
                        {
                            w2.disabledCheckbox = false;
                        }
                    }
                    else if(w1.ComponentName == 'Metric_Configuration_vod__c' && (w2.ComponentName == 'Product_vod__c' || w2.ComponentName == 'Product_Group_vod__c'))
                    {
                        if(w1.Selected)
                        {
                            w2.Selected = true;
                            w2.disabledCheckbox = true;
                        }
                        else
                        {
                            if(w2.ComponentName == 'Product_Group_vod__c')
                            {
                                w2.disabledCheckbox = false;
                            }
                            else
                            {
                                for(WrapComponents w3 : IncludedWrappedComponents)
                                {
                                    if(w3.ComponentName == 'Product_Group_vod__c' && !w3.Selected)
                                    {
                                        w2.disabledCheckbox = false;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }*/
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
        List<sObject> countries = new List<sObject>();
        Map<String,List<SObject>> sObjectMap = new Map<String,List<SObject>>();
        JSONParser ProductResponse;
        JSONParser EventConfigurationResponse;
        JSONParser MetricConfigurationResponse;
        JSONParser ProductGroupResponse;
        try
        {
            String[] ObjectsList = ObjectListHelper.split(';');
            for(String s : ObjectsList)
            {
                if(s == 'Country_vod__c')
                {
                    countries = CountryHandler(SessionID);
                }
                else if(s == 'EM_Event_Configuration_vod__c')
                {
                    EventConfigurationResponse = EventConfigurationHandler(SessionID);
                }
                else if(s == 'Product_vod__c')
                {
                    if(!(ObjectsList.Contains('Product_Group_vod__c') && ObjectsList.Contains('Metric_Configuration_vod__c')))
                    {
                        ProductResponse = ProductHandler(SessionID);
                    }
                }
                else if(s == 'Product_Group_vod__c')
                {
                    if(!ObjectsList.Contains('Metric_Configuration_vod__c'))
                    {
                        ProductResponse = ProductHandler(SessionID);
                        ProductGroupResponse = ProductGroupHandler(SessionID);
                    }
                }
                else if(s == 'Metric_Configuration_vod__c')
                {
                    ProductResponse = ProductHandler(SessionID);
                    ProductGroupResponse = ProductGroupHandler(SessionID);
                    MetricConfigurationResponse = MetricConfigurationHandler(SessionID);
                }
                else if(s != NULL)
                {
                    System.enqueueJob(new QueueImport(s,SessionID,null, ProdURL));
                    ProgressList.Add('A request has been submitted for fetching '+s+'. Please check Apex Jobs for progress.');
                   
                }
            }
            if(countries.size() > 0 && !ObjectsList.Contains('EM_Event_Configuration_vod__c'))
            {
                Database.SaveResult[] srList = Database.insert(countries,false);
                ProgressList.Add(srList.size()+' Country records inserted Successfully');
            }
            if(ProductResponse != NULL)
            {
                ProcessProducts(ProductResponse);
            }
            if(EventConfigurationResponse != NULL)
            {
                Database.SaveResult[] srList = Database.insert(countries,false);
                ProgressList.Add(srList.size()+' Country records inserted Successfully');
                ProcessEventConfiguration(EventConfigurationResponse);
            }
            if(ProductGroupResponse != NULL)
            {
                ProcessProductGroup(ProductGroupResponse);
            }
            if(MetricConfigurationResponse != NULL)
            {
                ProcessMetricConfiguration(MetricConfigurationResponse);
            }
            if(sObjectMap.size()>0)
            {
                for(String s : sObjectMap.KeySet())
                {
                    Database.SaveResult[] sObjectLoad= Database.insert(sObjectMap.get(s),false);
                    Integer count = 0;
                    for(Integer i = 0; i<sObjectLoad.size() ; i++)
                    {
                        if(!sObjectLoad[i].isSuccess())
                        {
                            System.debug('Failed records are '+sObjectLoad[i].getErrors());
                        }
                        else
                        {
                            Count++;
                        }        
                    }
                    ProgressList.add(count+' '+s+' records inserted successfully');
                }
            }
        }
        catch(Exception e)
        {
            ProgressList.Add('Driver Method failed due to '+e);
        }
    }
    
    Public List<sObject> CountryHandler(String ParentSessionID)
    {
        List<sObject> countries = new List<sObject>();
        try
        {
            HTTPRequest req = new HTTPRequest();
            String EndpointURL = ProdURL+'/services/data/v44.0/query?q=SELECT+Alpha_2_Code_vod__c,Country_Name_vod__c,Name,RecordTypeId,SRV_External_ID__c,SRV_INT_DP_Managed__c+FROM+Country_vod__c';
            req.setEndpoint(EndpointURL);
            req.setMethod('GET');
            req.setTimeout(60000);
            req.setHeader('Authorization','Bearer '+ParentSessionID);
            req.setHeader('Content-Type', 'application/json; charset=UTF-8');
            
            Type ObjectType = Type.forName('Country_vod__c');
            HTTPResponse response = new HTTP().send(req);
            System.debug('Countries Response Body '+response.getBody());
                   
            if(response.getStatusCode() == 200)
            {
                JSONParser parser = JSON.CreateParser(response.getBody());
                while(parser.nextToken() != NULL)
                {
                    if(parser.getCurrentToken() == JSONToken.START_ARRAY)
                    {
                        while(parser.nextToken() != NULL)
                        {
                            if(parser.getCurrentToken() == JSONToken.START_OBJECT)
                            {
                                sObject c = (sObject)parser.readValueAs(ObjectType);
                                countries.add(c);
                                parser.skipChildren();
                            }
                        }
                    }
                }
            }
            else
            {
                throw new CallOutException(response.getBody());
            }
        }
        catch(System.Exception e)
        {
            ProgressList.Add('Countries fetch failed due to '+e);
        }
        
        if(countries.size() > 0)
        {
            return countries;
        }
        return NULL;
    }
    Public JSONParser ProductHandler(String ParentSessionID)
    {
        JSONParser parser = NULL;
        try
        {
            HTTPRequest req = new HTTPRequest();
            String EndpointURL = ProdURL+'/services/data/v44.0/query?q=SELECT+id,Name,Country_Code__c,External_ID_vod__c,No_Cycle_Plans_vod__c,No_Details_vod__c,No_Metrics_vod__c,Parent_Product_vod__c,Product_Type_vod__c,+(+Select+id,Name,Country_Code__c,External_ID_vod__c,No_Cycle_Plans_vod__c,No_Details_vod__c,No_Metrics_vod__c,Product_Type_vod__c+FROM+Child_products_vod__r)+FROM+Product_vod__c';
            req.setEndpoint(EndpointURL);
            req.setMethod('GET');
            req.setTimeout(60000);
            req.setHeader('Authorization','Bearer '+ParentSessionID);
            req.setHeader('Content-Type', 'application/json; charset=UTF-8');
            
            HTTPResponse response = new HTTP().send(req);
            System.debug('Products Response Body '+response.getBody());
                   
            if(response.getStatusCode() == 200)
            {
                parser = JSON.CreateParser(response.getBody());
            }
            else
            {
                throw new CallOutException(response.getBody());
            }
        }
        catch(System.Exception e)
        {
            ProgressList.Add('Products fetch failed due to '+e);
        }
        return parser;
    }
    Public JSONParser ProductGroupHandler(String ParentSessionID)
    {
        JSONParser parser = NULL;
        try
        {
            HTTPRequest req = new HTTPRequest();
            String EndpointURL = ProdURL+'/services/data/v44.0/query?q=SELECT+Name,Description_vod__c,End_Date_vod__c,Product_vod__c,Product_Catalog_vod__c,Quantity_vod__c,Start_Date_vod__c+FROM+Product_Group_vod__c';
            req.setEndpoint(EndpointURL);
            req.setMethod('GET');
            req.setTimeout(60000);
            req.setHeader('Authorization','Bearer '+ParentSessionID);
            req.setHeader('Content-Type', 'application/json; charset=UTF-8');
            
            HTTPResponse response = new HTTP().send(req);
            System.debug('Product Groups Response Body '+response.getBody());
                   
            if(response.getStatusCode() == 200)
            {
                parser = JSON.CreateParser(response.getBody());
                //ProgressList.add(response.getBody());
            }
            else
            {
                throw new CallOutException(response.getBody());
            }
        }
        catch(System.Exception e)
        {
            ProgressList.Add('Product Groups fetch failed due to '+e);
        }
        return parser;
    }
    Public JSONParser MetricConfigurationHandler(String ParentSessionID)
    {
        JSONParser parser = NULL;
        try
        {
            HTTPRequest req = new HTTPRequest();
            String EndpointURL = ProdURL+'/services/data/v44.0/query?q=SELECT+Name,Active_vod__c,Applies_To_vod__c,SRV_INT_Country_Code__c,Detail_Group_vod__c,Detail_Topic_vod__c,Display_Order_vod__c,Metric_Type_vod__c,Red_Yellow_vod__c,Yellow_Green_vod__c+FROM+Metric_Configuration_vod__c';
            req.setEndpoint(EndpointURL);
            req.setMethod('GET');
            req.setTimeout(60000);
            req.setHeader('Authorization','Bearer '+ParentSessionID);
            req.setHeader('Content-Type', 'application/json; charset=UTF-8');
            
            HTTPResponse response = new HTTP().send(req);
            System.debug('Metric Configuration Response Body '+response.getBody());
                   
            if(response.getStatusCode() == 200)
            {
                parser = JSON.CreateParser(response.getBody());
                //ProgressList.add(response.getBody());
            }
            else
            {
                throw new CallOutException(response.getBody());
            }
        }
        catch(System.Exception e)
        {
            ProgressList.Add('Metric Configuration fetch failed due to '+e);
        }
        return parser;
    }
    Public void ProcessProducts(JSONParser ProductParser)
    {
        List<sObject> ParentProduct = new List<sObject>();
        List<sObject> ChildProduct = new List<sObject>();
        List<sObject> ChildProductToLoad = new List<sObject>();
        Type ObjectType = Type.forName('Product_vod__c');
        while(ProductParser.nextToken() != NULL)
        {
            if(ProductParser.getCurrentToken() == JSONToken.Start_Array)
            {
                while(ProductParser.nextToken() != NULL)
                {
                    if(ProductParser.getCurrentToken() == JSONToken.Start_Object)
                    {
                        sObject p = (sObject)ProductParser.readValueAs(ObjectType);
                        if(p.get('Parent_Product_vod__c') == NULL)
                        {    
                            //p.VExternal_Id_vod__c = '';
                            p.put('VExternal_Id_vod__c',p.ID);
                            //p.VExternal_Id_vod__c = p.ID;
                            for(sObject cp : p.getSObjects('Child_products_vod__r'))
                            {
                                //cp.VExternal_Id_vod__c = '';
                                cp.put('VExternal_Id_vod__c',p.id+'_'+cp.id);
                                cp.put('id',NULL);
                                ChildProduct.add(cp);
                            }
                            p.id = NULL;
                            ParentProduct.add(p);
                        }
                    }
                    ProductParser.skipChildren();
                }
            }
        }
        
        Map<String, sObject> ChildProductMap = new Map<String, sObject>();
        for(sObject p : ChildProduct)
        {
            ChildProductMap.put((String)p.get('VExternal_Id_vod__c'), p);
        }
        Database.SaveResult[] ParentProductResult = Database.insert(ParentProduct,false);
        Integer ParentCount = 0;
        for(Integer i = 0; i<ParentProductResult.size() ; i++)
        {
            if(!ParentProductResult[i].isSuccess())
            {
                System.debug('Failed Product records are '+ParentProductResult[i].getErrors());
            }
            else
            {
                ParentCount++;
            }
        }
        String query = 'Select id, VExternal_ID_vod__c from Product_vod__c';
        Map<id,sObject>  ParentProductMap = new Map<id,sObject>(Database.query(query));
        for (Integer i = 0; i < ParentProductResult.size(); i++) 
        {
            if (ParentProductResult[i].isSuccess()) 
            {
                string identifier = (String)ParentProductMap.get(ParentProductResult[i].getId()).get('VExternal_Id_vod__c');
                id ParentProductID = ParentProductResult[i].getId();
                for(sObject cp :  ChildProductMap.values())
                {
                    String temp = (String)cp.get('VExternal_ID_vod__c');
                    if(temp.substringBefore('_') == identifier)
                    {
                        cp.put('Parent_Product_vod__c', ParentProductID);
                        //ProgressList.Add(cp.Name+'_'+cp.External_ID_vod__c+'_'+cp.Parent_Product_vod__c+'_'+cp.Parent_Product_vod__r.External_ID_vod__c);
                        ChildProductToLoad.add(cp);
                    }
                }
            }
            else
            {
                ProgressList.add('failed'+ParentProductMap.get(ParentProductResult[i].getId()).get('VExternal_Id_vod__c'));
            }
        }
        Database.SaveResult[] ChildProductResult = Database.insert(ChildProductToLoad,false);
        integer ChildCount = 0;
        for(Integer i = 0; i<ChildProductResult.size() ; i++)
        {
            if(!ChildProductResult[i].isSuccess())
            {
                System.debug('Failed Product records are '+ChildProductResult[i].getErrors());
            }
            else
            {
                Childcount++;
            }
        }
        ProgressList.add(ParentCount+' Parent Products & '+ChildCount+' Child Products inserted successfully');
    }
    Public void ProcessProductGroup(JSONParser ProductCatalogParser)
    {
        List<sObject> ProductGroup = new List<sObject>();
        String query = 'Select id, VExternal_ID_vod__c from Product_vod__c';
        List<sObject> ProductList = Database.query(query);
        Map<String,String> ProductIDMap = new Map<String,String>();
        for(sObject prod : ProductList)
        {
            String temp = (String)prod.get('VExternal_Id_vod__c');
            System.debug('Temp String '+temp);
            System.debug('Production ID '+prod.id);
            if(!temp.contains('_'))
            {
                ProductIDMap.put(temp,prod.id);
            }
            else
            {
                ProductIDMap.put(temp.SubStringAfter('_'),prod.id);
            }
        }
        String Parent = '';
        String Child = '';
        Type ObjectType = Type.forName('Product_Group_vod__c');
        while(ProductCatalogParser.nextToken() != NULL)
        {
            if(ProductCatalogParser.getCurrentToken() == JSONToken.Start_Array)
            {
                while(ProductCatalogParser.nextToken() != NULL)
                {
                    if(ProductCatalogParser.getCurrentToken() == JSONToken.Start_Object)
                    {   
                        sObject p = (sObject)ProductCatalogParser.readValueAs(ObjectType);
                        Parent = (ID)p.get('Product_Catalog_vod__c');
                        Child = (ID)p.get('Product_vod__c');
                        if(ProductIDMap.containsKey(Parent))
                        {
                            p.put('Product_Catalog_vod__c', ProductIDMap.get(Parent));
                            if(ProductIDMap.containsKey(Child))
                            {
                                p.put('Product_vod__c',ProductIDMap.get(Child));
                            }
                            ProductGroup.add(p);
                        }
                        else
                        {
                            //ProgressList.add('failed to add');
                        }
                    }
                }
                ProductCatalogParser.skipChildren();
            }
        }
        Database.SaveResult[] ProductGroupLoad= Database.insert(ProductGroup,false);
        Integer count = 0;
        for(Integer i = 0; i<ProductGroupLoad.size() ; i++)
        {
            if(!ProductGroupLoad[i].isSuccess())
            {
                System.debug('Failed records are '+ProductGroupLoad[i].getErrors());
            }
            else
            {
                Count++;
            }
        }
        ProgressList.add(count+' Product Groups inserted successfully');
    }
    Public void ProcessMetricConfiguration(JSONParser MetricConfigParser)
    {
        List<sObject> Metrics = new List<sObject>();
        String query = 'Select id, VExternal_ID_vod__c from Product_vod__c';
        List<sObject> ProductList = Database.query(query);
        Map<String,String> ProductIDMap = new Map<String,String>();
        for(sObject prod : ProductList)
        {
            String temp = (String)prod.get('VExternal_Id_vod__c');
            if(!temp.contains('_'))
            {
                ProductIDMap.put(temp,prod.id);
            }
            else
            {
                ProductIDMap.put(temp.SubStringAfter('_'),prod.id);
            }
        }
        String Parent = '';
        Type ObjectType = Type.forName('Metric_Configuration_vod__c');
        while(MetricConfigParser.nextToken() != NULL)
        {
            if(MetricConfigParser.getCurrentToken() == JSONToken.Start_Array)
            {
                while(MetricConfigParser.nextToken() != NULL)
                {
                    if(MetricConfigParser.getCurrentToken() == JSONToken.Start_Object)
                    {   
                        sObject p = (sObject)MetricConfigParser.readValueAs(ObjectType);
                        Parent = (ID)p.get('Detail_Group_vod__c');
                        if(ProductIDMap.containsKey(Parent))
                        {
                            p.put('Detail_Group_vod__c',ProductIDMap.get(Parent));
                            //p.Detail_Group_vod__c = ProductIDMap.get(Parent);
                        }
                        Metrics.add(p);
                    }
                }
                MetricConfigParser.skipChildren();
            }
        }
        Database.SaveResult[] MetricsLoad= Database.insert(Metrics,false);
        Integer count = 0;
        for(Integer i = 0; i<MetricsLoad.size() ; i++)
        {
            if(!MetricsLoad[i].isSuccess())
            {
                System.debug('Failed records are '+MetricsLoad[i].getErrors());
            }
            else
            {
                Count++;
            }
        }
        ProgressList.add(count+' Metric configurations inserted successfully');
    }
    Public JSONParser EventConfigurationHandler(String ParentSessionID)
    {
        JSONParser parser = NULL;
        try
        {
            HTTPRequest req = new HTTPRequest();
            String EndpointURL = ProdURL+'/services/data/v44.0/query?q=SELECT+id,End_Date_vod__c,External_ID_vod__c,Event_Type_vod__c,Name,RecordTypeId,Start_Date_vod__c,+(+SELECT++country_Override_vod__c,External_id__c,Event_Configuration_vod__c,Event_Layout_vod__c,Event_Object_Name_vod__c,Event_Status_vod__c,Event_Team_Role_vod__c,Expense_Estimate_Layout_vod__c,Expense_Header_Layout_vod__c,Expense_Line_Layout_vod__c,Help_Text_vod__c,Name,Page_Layout_vod__c,RecordTypeId,Record_Type_vod__c,User_Profile_Id_vod__c,User_Profile_vod__c,Visible_Buttons_vod__c+FROM+EM_Event_Layout_vod__r),(SELECT+id,Country_vod__r.Alpha_2_Code_vod__c,+Event_Configuration_vod__c,External_ID_vod__c,RecordTypeId+FROM+Event_Configuration_Country_vod__r),(SELECT+Account_Attendee_Fields_vod__c,Contact_Attendee_Fields_vod__c,Event_Configuration_vod__c,External_ID_vod__c,Filter_Type_vod__c,Online_Registration_Fields_vod__c,Qualification_vod__c,RecordTypeId,Speaker_Fields_vod__c,User_Attendee_Fields_vod__c,Walk_In_Attendee_Statuses_vod__c,Walk_In_Fields_vod__c+FROM+Event_Rules__r),(SELECT+Allow_Comments_vod__c,Approver_Role_vod__c,Button_Name_vod__c,Confirmation_Message_vod__c,Ending_Status_vod__c,Entry_Criteria_Not_Met_Message_vod__c,Event_Configuration_vod__c,External_ID_vod__c,RecordTypeId,SFDC_Action_Type_vod__c,Starting_Status_vod__c+FROM+Event_Configuration_vod__r)+FROM+EM_Event_Configuration_vod__c+Where+End_date_vod__c+%3E+TODAY';
            req.setEndpoint(EndpointURL);
            req.setMethod('GET');
            req.setTimeout(60000);
            req.setHeader('Authorization','Bearer '+ParentSessionID);
            req.setHeader('Content-Type', 'application/json; charset=UTF-8');
            
            HTTPResponse response = new HTTP().send(req);
            System.debug('Event Configuration Response Body '+response.getBody());
                   
            if(response.getStatusCode() == 200)
            {
                parser = JSON.CreateParser(response.getBody());
            }
            else
            {
                throw new CallOutException(response.getBody());
            }
        }
        catch(System.Exception e)
        {
            ProgressList.Add('Event Configuration fetch failed due to '+e);
        }
        return parser;
    }
    Public void ProcessEventConfiguration(JSONParser EventConfigParser)
    {
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
        /*String CountryQuery = 'SELECT id,Name from Country_vod__c';
        List<sObject> countryList = Database.Query(CountryQuery);
        for(sObject c : countryList)
        {
            CountryMap.put((String)c.get('Name'),c);
        }*/
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
                        system.debug('Record Type ID'+em.get('recordtypeid'));
                        System.debug('End date'+em.get('End_Date_vod__c'));
                        List<sObject> EMLayoutTemp = new List<sObject>();
                        if(em.getSObjects('EM_Event_Layout_vod__r') != NULL)
                        {
                            EMLayoutTemp = em.getSObjects('EM_Event_Layout_vod__r');
                        }
                        system.debug('Layout Size '+EMLayoutTemp.size());
                        List<sObject> EMCountryTemp = new List<sObject>();
                        if(em.getSObjects('Event_Configuration_Country_vod__r') != NULL)
                        {
                            EMCountryTemp = em.getSObjects('Event_Configuration_Country_vod__r');
                        }
                        system.debug('Country Size'+EMCountryTemp.size());
                        //System.debug('Count check for null pointer exception '+count);
                        if(EMLayoutTemp.size() >0 && em.get('recordtypeid') != null && EMCountryTemp.size() > 0)
                        {
                            em.put('External_ID_vod__c', '');
                            em.put('External_ID_vod__c' , em.id);
                            em.put('id',NULL);
                            a.add(em);
                            System.debug('entered');
                            
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
                                System.debug('Country Added');
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
        ProgressList.add(count+' Event Configuration Records Inserted');
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
            else 
            {
                System.debug('Error: could not create sobject ' + 'for array element ' + i + '.');
                strInsertError = 'The error reported was: ' + results[i].getErrors()[0].getMessage() + '\n';
                System.debug(strInsertError);
                
            }
        }
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
            }
        }
        //ProgressList.add(count+' Event Layout Records Inserted');
        
        Database.SaveResult[] results2 = Database.insert(UpEm_countryList,false);
        count = 0;
        for(Integer i = 0; i < results2.size(); i++)
        {
            if(results2[i].isSuccess())
            {
                count++;
            }
            else
            {
                System.debug('Event Configuration Country Failed due to '+results2[i].getErrors());
            }
        }
        //ProgressList.add(count+' Event Configuration Country Records Inserted');
        
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
            }
        }
        //ProgressList.add(count+' Event Action Records Inserted');
    }
}