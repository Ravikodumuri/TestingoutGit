public class Veevatization_ProductHandler implements Queueable, Database.AllowsCallouts
{
    String EventConfigBody;
    String ParentSessionID;
    String EndPointURL;
    String ProdURL;
    public Veevatization_ProductHandler(String ParentSessionID, String ProdURL , String NewRecordsURL)
    {
        this.ParentSessionID = ParentSessionID;
        this.ProdURL = ProdURL;
        Boolean done = true;
        if(NewRecordsURL == NULL)
        {
            this.EndpointURL = ProdURL+'/services/data/v44.0/query?q=SELECT+id,Name,Country_Code__c,External_ID_vod__c,No_Cycle_Plans_vod__c,No_Details_vod__c,No_Metrics_vod__c,Parent_Product_vod__c,Product_Type_vod__c,+(+Select+id,Name,Country_Code__c,External_ID_vod__c,No_Cycle_Plans_vod__c,No_Details_vod__c,No_Metrics_vod__c,Product_Type_vod__c+FROM+Child_products_vod__r)+FROM+Product_vod__c';
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
            JSONParser ProductParser = JSON.createParser(response.getBody());
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
            for(Integer i = 0; i<ParentProductResult.size() ; i++)
            {
                if(!ParentProductResult[i].isSuccess())
                {
                    System.debug('Failed Product records are '+ParentProductResult[i].getErrors());
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
                            ChildProductToLoad.add(cp);
                        }
                    }
                }
                else
                {
                    system.debug('failed'+ParentProductMap.get(ParentProductResult[i].getId()).get('VExternal_Id_vod__c'));
                }
            }
            Database.SaveResult[] ChildProductResult = Database.insert(ChildProductToLoad,false);
            for(Integer i = 0; i<ChildProductResult.size() ; i++)
            {
                if(!ChildProductResult[i].isSuccess())
                {
                    System.debug('Failed Product records are '+ChildProductResult[i].getErrors());
                }
            }
            if(NewRecordsLinkUrlLink != NULL)
            {
                System.debug('New Records URL Link is called again '+NewRecordsLinkUrlLink);
                System.enqueueJob(new Veevatization_ProductHandler(ParentSessionID,ProdURL, NewRecordsLinkUrlLink));
            }
        
        }
        catch(System.Exception e)
        {
            System.debug('Product fetch failed due to '+e);
        }
    }
}