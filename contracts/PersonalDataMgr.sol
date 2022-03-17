// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.8.0;

import "./UserProfileMgr.sol";
import "./ConsentMgr.sol";


/*
*@Title :  Personal Data Managment Smart Contract 
*   	   Developed by Merlec Mpyana M. 
* 		   Email: mlecjm(a)korea.ac.kr 
*		   Intelligent Blockchain Engineering Lab, Korea University
*/

contract PersonalDataMgr{
    
    event newDataSetAdded (string _dataSetID, string _dataSetName, string _category, address indexed _dataProvider);
    event dataSetUpdated (string _dataSetID, address indexed _dataProvider, string _version, uint _lastUpdate);
    event dataSetDeleted (string _dataSetID, address indexed _dataProvider, address indexed _deletedBy, uint _erasureTimestamp);
    event dataSetAccessed (string _dataSetID, address indexed _accessedBy, string _from, uint _atTimestamp);
    event dataSetProcessed (string _dataSetID, address indexed _processedBy, string _from, uint _atTimestamp);
    
    //Personal Data structure definition 
    struct PersonalData{
        string dataSetID;
        string dataSetName;
        string category; 
        string description;
        address dataProvider;
        string dataHashValue;
        string accessLink;
        string version;
        uint lastUpdate;
        bool isPersonal;
        bool isSensitive;
    }
    
    mapping (string => PersonalData) DataSets;
    string[] public DataSetList;
    //address public owner;
    //string private link;
    
    
    //Add a new Personal Data Set 
    function addNewDataSet(
        string memory _dataSetID, 
        string memory _dataSetName,
        string memory _category,
        string memory _description,
        address _dataProvider,
        string memory _dataHashValue,
        string memory _accessLink,
        string memory _version,
        bool _isPersonal,
        bool _isSensitive) 
        public {
            require(msg.sender == _dataProvider, "Only Data Provider this action!");
            DataSets[_dataSetID].dataSetName = _dataSetName;
            DataSets[_dataSetID].category = _category;
            DataSets[_dataSetID].description = _description;
            DataSets[_dataSetID].dataProvider = _dataProvider;
            DataSets[_dataSetID].dataHashValue = _dataHashValue;
            DataSets[_dataSetID].accessLink = _accessLink;
            DataSets[_dataSetID].version = _version;
            DataSets[_dataSetID].lastUpdate = block.timestamp;
            DataSets[_dataSetID].isPersonal = _isPersonal;
            DataSets[_dataSetID].isSensitive = _isSensitive;
            
            DataSetList.push(_dataSetID);
            emit newDataSetAdded (_dataSetID, _dataSetName, _category, _dataProvider);
    }
    
    // Check if the message sender is dataProvider for the dataSet
    function isdataProvider(string memory _dataSetID) view public returns(bool){
        if(msg.sender == DataSets[_dataSetID].dataProvider ){
             return true;
        } 
        return false;
    } 
    
    // Check if a DataSet is Personal
    function isPersonal(string memory _dataSetID) view public returns(bool){
            return DataSets[_dataSetID].isPersonal;
    }
    
    // Check if a DataSet is Sensitive
    function isSensitive(string memory _dataSetID) view public returns(bool){
            return DataSets[_dataSetID].isSensitive;
    }
    
    //Get a specific DataSet detailed Information 
    function getDataSetInfo(string memory _dataSetID) 
        view 
        public 
        returns (string memory, string memory, string memory, address, string memory, bool, bool){
            return (DataSets[_dataSetID].dataSetName,
                    DataSets[_dataSetID].category,
                    DataSets[_dataSetID].description,
                    DataSets[_dataSetID].dataProvider,
                    DataSets[_dataSetID].dataHashValue,
                    DataSets[_dataSetID].isPersonal,
                    DataSets[_dataSetID].isSensitive);
        }
    

    // Count the number of DataSets 
    function countDataSets() view public returns(uint) {
        return DataSetList.length;
    }
    
    
    //Update a Personal Data Set 
    function updateDataSet(
        string memory _dataSetID, 
        string memory _dataSetName,
        string memory _category,
        string memory _description,
        address _dataProvider,
        string memory _dataHashValue,
        string memory _accessLink,
        string memory _version,
        bool _isPersonal,
        bool _isSensitive) 
        public {
            require(msg.sender == _dataProvider, "Only Data Provider this action!");
            DataSets[_dataSetID].dataSetName = _dataSetName;
            DataSets[_dataSetID].category = _category;
            DataSets[_dataSetID].description = _description;
            DataSets[_dataSetID].dataProvider = _dataProvider;
            DataSets[_dataSetID].dataHashValue = _dataHashValue;
            DataSets[_dataSetID].accessLink = _accessLink;
            DataSets[_dataSetID].version = _version;
            DataSets[_dataSetID].lastUpdate = block.timestamp;
            DataSets[_dataSetID].isPersonal = _isPersonal;
            DataSets[_dataSetID].isSensitive = _isSensitive;
            
            emit dataSetUpdated (_dataSetID, _dataProvider, _version, block.timestamp);

    }
 
    modifier OnlyOwner {
        require (msg.sender == owner);
	    _;
    }
   
}