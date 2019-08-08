public class Veevatization_ProductGroupHandler implements Queueable, Database.AllowsCallouts
{
    String EventConfigBody;
    String ParentSessionID;
    String EndPointURL;
    String ProdURL;
    public Veevatization_ProductGroupHandler(String ParentSessionID, String ProdURL , String NewRecordsURL)
    {
        this.ParentSessionID = ParentSessionID;
        this.ProdURL = ProdURL;
        Boolean done = true;
        if(NewRecordsURL == NULL)
        {
            this.EndpointURL = ProdURL+'/services/data/v44.0/query?q=SELECT+Name,Description_vod__c,End_Date_vod__c,Product_vod__c,Product_Catalog_vod__c,Quantity_vod__c,Start_Date_vod__c+FROM+Product_Group_vod__c';
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
            JSONParser ProductCatalogParser = JSON.createParser(response.getBody());
        
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
            for(Integer i = 0; i<ProductGroupLoad.size() ; i++)
            {
                if(!ProductGroupLoad[i].isSuccess())
                {
                    System.debug('Failed records are '+ProductGroupLoad[i].getErrors());
                }
            }
            //ProgressList.add(count+' Product Groups inserted successfully');
           
            if(NewRecordsLinkUrlLink != NULL)
            {
                System.debug('New Records URL Link is called again '+NewRecordsLinkUrlLink);
                System.enqueueJob(new Veevatization_ProductGroupHandler(ParentSessionID,ProdURL, NewRecordsLinkUrlLink));
            }
        
        }
        catch(System.Exception e)
        {
            System.debug('Product Group fetch failed due to '+e);
        }
    }
}