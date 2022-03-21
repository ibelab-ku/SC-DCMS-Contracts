// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.8.0;

import "./ConsentMgr.sol";

/*
*@Title :  User Profile Managment Contract 
*   	   Developed by Merlec Mpyana M. 
* 	    Email: mlecjm(a)korea.ac.kr 
*	    Intelligent Blockchain Engineering Lab, Korea University
*/

contract UserProfileMgr{
    
    event newUserProfileCreated(address indexed _uProfileID, bool _isDataSubject, bool _isDataController, bool isRegulator, bool _isDataProcessor, bool _isApproved);
    event userProfileUpdated(address indexed _uProfileID, bool _isDataSubject, bool _isDataController, bool _isRegulator);
    event roleApprovalRequested(string _roleRequestNum, address indexed _roleRequesterID, bool _isRequested);
    event roleApproved(string _roleRequestNum, address indexed _roleRequesterID, address indexed _roleApproverID, bool _isRoleApproved);
    event userProfileRevoked(address indexed _uProfileID, address indexed _revokerID, bool _isRevoked);
    
    struct UserProfile {
        string subscriptionNum;
        string idCardNumber; 
        string fullName;
        uint256 birthDay;
        bool isDataSubject;
        bool isDataController;
        bool isDataProcessor;
        bool isRegulator;
        bool isRoleApproved;
        bool isDelagated;
        bool isRevoked;
    }
    
    struct RoleApprovalRequest{
        string roleRequestNum;
        address roleRequesterID;
        address roleApproverID;
        string requestDetails;
        bool isRequested;
        bool isProcessed;
    }
    
    mapping (address => UserProfile) Profiles;
    address[] public UserProfiles;
    
    mapping(string => RoleApprovalRequest) RoleApprovalRequests;
    string[] public RoleApprovalRequestList;
    
    //Function to create a user profile 
    function createUserProfile(
        address _uProfileID, 
        string memory _idCardNumber,
        string memory _fullName,
        string memory _subscriptionNum,
        uint256 _birthDay,
        bool _isDataSubject,
        bool _isDataController,
        bool _isDataProcessor,
        bool _isRegulator,
        bool _isDelagated,
        bool _isRevoked) public {
            Profiles[_uProfileID].idCardNumber = _idCardNumber;
            Profiles[_uProfileID].fullName = _fullName;
            Profiles[_uProfileID].subscriptionNum = _subscriptionNum;
            Profiles[_uProfileID].birthDay = _birthDay;
            Profiles[_uProfileID].isDataSubject = _isDataSubject;
            Profiles[_uProfileID].isDataController = _isDataController;
            Profiles[_uProfileID].isRegulator = _isRegulator;
            Profiles[_uProfileID].isDataProcessor = _isDataProcessor;
            Profiles[_uProfileID].isRoleApproved = false;
            Profiles[_uProfileID].isDelagated = _isDelagated;
            Profiles[_uProfileID].isRevoked = _isRevoked;
            
            UserProfiles.push(_uProfileID);
            
            emit newUserProfileCreated(_uProfileID, _isDataSubject, _isDataController, _isRegulator, _isDataProcessor, false);
        }
        
         // Count the number of UserProfiles 
        function countUserProfiles() view public returns(uint256) {
            return UserProfiles.length;
        }
        
        // Get all the UserProfiles account address
        function getUserProfiles() view public returns(address[] memory){
            return UserProfiles;
        }
        
        // Check if a user is a DataSubject 
        function isDataSubject(address _uProfileID) view public returns(bool){
            return Profiles[_uProfileID].isDataSubject;
        }
        
        // Check if a user is a DataController  
        function isDataController(address _uProfileID) view public returns(bool){
            return Profiles[_uProfileID].isDataController;
        }
        
         // Check if a user is a Regulator  
        function isRegulator(address _uProfileID) view public returns(bool){
            return Profiles[_uProfileID].isRegulator;
        }
        
         // Check if a user profile is a Delegated   
        function isDelagated(address _uProfileID) view public returns(bool){
            return Profiles[_uProfileID].isDelagated;
        }
        
        //Get a specific userProfile information 
        function getUserProfile(address _uProfileID) 
        view 
        public 
        returns (string memory fullName, 
                 string memory subscriptionNum, 
                 uint256 birthDay, 
                 bool _isDataSubject, 
                 bool _isDataController, 
                 bool _isRegulator, 
                 bool _isRevoked){
            return (Profiles[_uProfileID].fullName,
                    Profiles[_uProfileID].subscriptionNum,
                    Profiles[_uProfileID].birthDay,
                    Profiles[_uProfileID].isDataSubject,
                    Profiles[_uProfileID].isDataController,
                    Profiles[_uProfileID].isRegulator,
                    Profiles[_uProfileID].isRevoked);
        }
        
        
    //Function to update a user profile 
    function updateUserProfile(
        address _uProfileID, 
        string memory _idCardNumber,
        string memory _fullName,
        string memory _subscriptionNum,
        uint256 _bithDay,
        bool _isDataSubject,
        bool _isDataController,
        bool _isRegulator,
        bool _isDelagated,
        bool _isRevoked) 
        public 
        returns (bool success) {
            Profiles[_uProfileID].idCardNumber = _idCardNumber;
            Profiles[_uProfileID].fullName = _fullName;
            Profiles[_uProfileID].subscriptionNum = _subscriptionNum;
            Profiles[_uProfileID].birthDay = _bithDay;
            Profiles[_uProfileID].isDataSubject = _isDataSubject;
            Profiles[_uProfileID].isDataController = _isDataController;
            Profiles[_uProfileID].isRegulator = _isRegulator;
            //Profiles[_uProfileID].isRoleApproved = false;
            Profiles[_uProfileID].isDelagated = _isDelagated;
            Profiles[_uProfileID].isRevoked = _isRevoked;
            
            emit userProfileUpdated(_uProfileID, _isDataSubject, _isDataController, _isRegulator);
            
            return (success = true);
        }
        
        // Request for role role approval 
        function requestRoleApproval(
            string memory _roleRequestNum, 
            address _roleRequesterID,
            string memory _requestDetails) 
        public returns(bool _isRequested) {
            
            RoleApprovalRequests[_roleRequestNum].roleRequesterID = _roleRequesterID;
            RoleApprovalRequests[_roleRequestNum].requestDetails = _requestDetails;
            RoleApprovalRequests[_roleRequestNum].isRequested = true;
            RoleApprovalRequests[_roleRequestNum].isProcessed = false;
            
            RoleApprovalRequestList.push(_roleRequestNum);
            
            emit roleApprovalRequested(_roleRequestNum, _roleRequesterID, 
                                      RoleApprovalRequests[_roleRequestNum].isRequested);
            
            return (RoleApprovalRequests[_roleRequestNum].isRequested) ;
        
        }
        
        //Get information about a role approval role request 
        function getRequestRoleApprovalInfo(string memory _roleRequestNum)
        public
        view
        returns(
            address roleRequesterID, 
            string memory requestDetails, 
            bool isRequested, 
            bool isProcessed){
            
            return( RoleApprovalRequests[_roleRequestNum].roleRequesterID,
                    RoleApprovalRequests[_roleRequestNum].requestDetails,
                    RoleApprovalRequests[_roleRequestNum].isRequested,
                    RoleApprovalRequests[_roleRequestNum].isProcessed);
        }
        
        

        // Approve a role approval request by a DataController or Regulator  
        function approveRole(
            //string memory _approvalNum,
            string memory _roleRequestNum, 
            address _roleRequesterID, 
            address _roleApproverID) 
        public 
        returns(bool isProcessed)
        {
            require((RoleApprovalRequests[_roleRequestNum].isRequested == true) 
            && (Profiles[_roleApproverID].isRegulator = true) || (Profiles[_roleApproverID].isDataController = true), 
            "Request is not sumitted yet !");
            
            Profiles[_roleRequesterID].isRoleApproved = true;
            
            RoleApprovalRequests[_roleRequestNum].roleApproverID = _roleApproverID;
            
            emit roleApproved(_roleRequestNum, _roleRequesterID, _roleApproverID, Profiles[_roleRequesterID].isRoleApproved);
            
            return (RoleApprovalRequests[_roleRequestNum].isProcessed = true);
        }
        
        
        //Get role approval information
        function getApproveRoleInfo(string memory _roleRequestNum)
        view
        public
        returns(address _roleRequesterID, address _roleApproverID, 
                bool isRoleApproved, bool isProcessed){
            
            return( RoleApprovalRequests[_roleRequestNum].roleRequesterID,
                    RoleApprovalRequests[_roleRequestNum].roleApproverID,
                    Profiles[_roleRequesterID].isRoleApproved,
                    RoleApprovalRequests[_roleRequestNum].isProcessed );
        }


        // Revoke a User Profile by a DataController or a Regulator 
        function revokeUserProfile(address _userProfileID, address _revokerID) 
        public 
        returns(bool){
            
            require(Profiles[_userProfileID].isRevoked == false, "User Profile already Revoked!");
            
            require((Profiles[_revokerID].isRegulator = true) || (Profiles[_revokerID].isDataController = true) , 
            "Only DataController or Regulator can revoke a user!");
            
            Profiles[_userProfileID].isRevoked = true;
           
            emit userProfileRevoked(_userProfileID, _revokerID, Profiles[_userProfileID].isRevoked);
            
            return (Profiles[_userProfileID].isRevoked = true);
        }
        
        // Check if a user profile is isRevoked  
        function isRevoked(address _uProfileID) view public returns(bool){
            return Profiles[_uProfileID].isRevoked;
        }
        
}
