public class Veevatization_MetricConfigurationHandler implements Queueable, Database.AllowsCallouts
{
    String EventConfigBody;
    String ParentSessionID;
    String EndPointURL;
    String ProdURL;
    public Veevatization_MetricConfigurationHandler(String ParentSessionID, String ProdURL , String NewRecordsURL)
    {
        this.ParentSessionID = ParentSessionID;
        this.ProdURL = ProdURL;
        Boolean done = true;
        if(NewRecordsURL == NULL)
        {
            this.EndpointURL = ProdURL+'/services/data/v44.0/query?q=SELECT+Name,Active_vod__c,Applies_To_vod__c,SRV_INT_Country_Code__c,Detail_Group_vod__c,Detail_Topic_vod__c,Display_Order_vod__c,Metric_Type_vod__c,Red_Yellow_vod__c,Yellow_Green_vod__c+FROM+Metric_Configuration_vod__c';
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
            JSONParser MetricConfigParser = JSON.createParser(response.getBody());
        
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
            for(Integer i = 0; i<MetricsLoad.size() ; i++)
            {
                if(!MetricsLoad[i].isSuccess())
                {
                    System.debug('Failed records are '+MetricsLoad[i].getErrors());
                }
            }
               
            if(NewRecordsLinkUrlLink != NULL)
            {
                System.debug('New Records URL Link is called again '+NewRecordsLinkUrlLink);
                System.enqueueJob(new Veevatization_MetricConfigurationHandler(ParentSessionID,ProdURL, NewRecordsLinkUrlLink));
            }
        
        }
        catch(System.Exception e)
        {
            System.debug('Metric Configuration fetch failed due to '+e);
        }
    }
}