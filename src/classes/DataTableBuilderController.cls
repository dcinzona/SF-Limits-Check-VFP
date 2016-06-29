global with sharing class DataTableBuilderController {
    
    public string dataTableId {get;set;}
    
    public string getUniqueTableId(){
        PageReference pageRef = ApexPages.currentPage();
        String fullUrl = pageRef.getUrl();
        String[] splitUrl = fullUrl.split('[?]');
        
		return splitUrl[0] + '_' + dataTableId;
    }
    
    public static DataTableSettings__c getDTSettingsObj(string dataTableId){
        
        String name = dataTableId;
        
        List<DataTableSettings__c> settings = [SELECT Name, SettingJson__c FROM DataTableSettings__c 
                                              WHERE CreatedById = :UserInfo.getUserId()
                                              AND Name = :name LIMIT 1];
        DataTableSettings__c setting = new DataTableSettings__c();
        
        if(settings.size() > 0){
            setting = settings[0];
        }else{
            setting.Name = name;
        }
        
        System.debug('Settings >>>>> ');
        System.debug(setting);
        return setting;
    }
    
    public string getDataTableSettings(){
        
        String fullRefDTId = 'DataTables_'+getUniqueTableId();
        system.debug('fullTableID: ' + fullRefDTId);
        
        DataTableSettings__c setting = DataTableBuilderController.getDTSettingsObj(fullRefDTId);
        
        return setting.SettingJson__c;//'{id:"DataTable_'+dataTableId+'", settings:{}, userId: "'+UserInfo.getUserId()+'"}';
    }
    
    webservice static string saveSettings(string uniqueTableId, string settings){
        DataTableSettings__c setting = DataTableBuilderController.getDTSettingsObj(uniqueTableId);
        setting.SettingJson__c = settings;
        upsert setting;
        return setting.SettingJson__c;//'{id:"DataTable_'+tableId+'", settings:'+settings+', userId: "'+UserInfo.getUserId()+'"}';
    }
    
}