// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.8.0;

//import "./UserProfileMgr.sol";
//import "./PersonalDataMgr.sol";

/*
*@Title :  Dynamic Consent Managment Smart Contract
*   	   Developed by Merlec Mpyana M.
* 		   Email: mlecjm(a)korea.ac.kr
*		   Intelligent Blockchain Engineering Lab, Korea University
*/

contract ConsentAgreementMgr{

    event usageOperationSet(string _uOpCode, string _uOpDescription, address indexed _setBy );
    event consentRequestCreated(string _consentReqID, address indexed _requestedBy, address indexed _dataSubjectID);
    event consentAgreementMade(string _agrNum, string _consentReqID, bool _isValid, address indexed agreedBy);
    event consentAgreementUpdated(string _agrNum, uint256 _lastUpdate, address indexed updatedBy);
    event consentAgreementExpired(string _agrNum, bool _isValid, bool _isExpired, address indexed approvedBy);


     //Consent Request Contract Structure
     struct ConsentContract{
        string consentReqID;
        address dataSubjectID;
        address requestedBy;
        string dataSetID;
        string purposeCode;
        uint256 creationDateTime;
        string uOpCode;
        RequestStatus requestStatus;
        LawsAndRegulations legislationBasis;
        string territory;
        string contractVersion;
    }

    // Consent Request
     enum RequestStatus{
         Requested, Agreed, Signed, Published,
         Expired, Withdrawn, Disagreed, Rejected
    }

    //Personal Data Protection Laws and Regulations
    enum LawsAndRegulations{
         GDPR,   //UE General Data Protection Regulations
         CCPA,   //California Consumer Protection Privacy Act
         PIPA,   //Personal Information Protection Act - S. Korea
         PIPL,   //Personal Information Protection Laws
         PIPEDA, //Personal Information Protection and Electronic Documents Act
         ePR,    //EU ePrivacy Regulation
         LGPD,   //Brazilian General Data Protection Law
         Other } //If Other Please provide the Details

    //Data Usage Operations
    struct Operations{
        string uOpCode;
        string uOpDescription;
        address setBy;
        bool isCollect;
        bool isStore;
        bool isProcess;
        //bool isShare;
        bool isDisclose;
        bool isPublish;
        bool isErasure;
    }

    //ConsentAgreement Related Details
    struct ConsentAgreement{
        string agreementNum;
        string consentReqID;
        string dSSignature;
        string requesterSignature;
        uint256 startDateTime;
        uint256 endDateTime;
        address agreedBy;
        uint lastUpdate;
        address updatedBy;
        bool isSigned;
        bool isValid;
        bool isExpired;
        bool _isWithdrawn ;
    }

    mapping(string => Operations) UsageOperation;
    string[] public UsageOperationList;

    mapping (string => ConsentContract) ConsentContracts;
    string[] public ConsentRequestList;

     mapping (string => ConsentAgreement) ConsentAgreements;
     string[] public ConsentAgreementList;

    //Set Consent Permitted Usage Operations
    function setUsageOperations(
        string memory _uOpCode,
        string memory _uOpDescription,
        address _setBy,
        bool _isCollect,
        bool _isStore,
        bool _isProcess,
        //bool _isShare,
        bool _isDisclose,
        bool _isErasure,
        bool _isPublish) public returns (bool success){

            UsageOperation[_uOpCode].uOpDescription = _uOpDescription;
            UsageOperation[_uOpCode].setBy = _setBy;
            UsageOperation[_uOpCode].isCollect = _isCollect;
            UsageOperation[_uOpCode].isStore = _isStore;
            UsageOperation[_uOpCode].isProcess = _isProcess;
            //UsageOperation[_uOpCode].isShare = _isShare;
            UsageOperation[_uOpCode].isDisclose = _isDisclose;
            UsageOperation[_uOpCode].isErasure = _isErasure;
            UsageOperation[_uOpCode].isPublish = _isPublish;

            UsageOperationList.push(_uOpCode);

            emit usageOperationSet(_uOpCode, _uOpDescription, _setBy);

            return (success = true);
    }

    // Consent Request function
    function newConsentRequest(
        string memory _consentReqID,
        address _dataSubjectID,
        address _requestedBy,
        string memory _dataSetID,
        string memory _purposeCode,
        string memory _uOpCode,
        string memory _contractVersion,
        //LawsAndRegulations _legislationBasis,
        string memory _territory)
        public {
            require(msg.sender != _dataSubjectID,
                    "Only Data Consumers can perform this operation!");

           //require(Profiles[msg.sender].isDataSubject == false,
           //        "Only Data Consumers can perform this operation!");

            ConsentContracts[_consentReqID].dataSubjectID = _dataSubjectID;
            ConsentContracts[_consentReqID].requestedBy = _requestedBy;
            ConsentContracts[_consentReqID].dataSetID = _dataSetID;
            ConsentContracts[_consentReqID].purposeCode = _purposeCode;
            ConsentContracts[_consentReqID].creationDateTime = block.timestamp;
            ConsentContracts[_consentReqID].uOpCode = _uOpCode;
            ConsentContracts[_consentReqID].contractVersion = _contractVersion;
            ConsentContracts[_consentReqID].legislationBasis = LawsAndRegulations.GDPR;
            ConsentContracts[_consentReqID].territory = _territory;
            ConsentContracts[_consentReqID].requestStatus = RequestStatus.Requested;

            ConsentRequestList.push(_consentReqID);

            emit consentRequestCreated(_consentReqID, _requestedBy, _dataSubjectID);
    }

    function countConsentRequest() view public returns(uint){
        return ConsentRequestList.length;
    }

    function getConsentRequestInfo(string memory _consentReqID)
        view
        public
        returns(address, address,  string memory, string memory, uint, string memory,
                //LawsAndRegulations, RequestStatus,
                string memory)
        {
            return( ConsentContracts[_consentReqID].dataSubjectID,
                    ConsentContracts[_consentReqID].requestedBy,
                    ConsentContracts[_consentReqID].dataSetID,
                    ConsentContracts[_consentReqID].purposeCode,
                    ConsentContracts[_consentReqID].creationDateTime,
                    ConsentContracts[_consentReqID].uOpCode,
                    //ConsentContracts[_consentReqID].legislationBasis,
                    //ConsentContracts[_consentReqID].requestStatus,
                    ConsentContracts[_consentReqID].territory );
        }


    // Consent Agreement function
    function newConsentAgreement(
            string memory _agrNum,
            string memory _consentReqID,
            string memory _dSSignature,
            string memory _requesterSignature,
            //uint256 _startDateTime,
            uint256 _endDateTime)
            public
            returns(bool success)
            {
                ConsentAgreements[_agrNum].consentReqID = _consentReqID;
                ConsentAgreements[_agrNum].dSSignature = _dSSignature;
                ConsentAgreements[_agrNum].requesterSignature = _requesterSignature;
                ConsentAgreements[_agrNum].startDateTime = block.timestamp;
                ConsentAgreements[_agrNum].lastUpdate = block.timestamp;
                ConsentAgreements[_agrNum].endDateTime = _endDateTime;
                ConsentAgreements[_agrNum].agreedBy = msg.sender;

                require((bytes(_dSSignature).length != 0) && (bytes(_requesterSignature).length != 0),
                        "Both signatures from DS and DC are required!");

                ConsentAgreements[_agrNum].isSigned = true;
                ConsentAgreements[_agrNum].isValid = true;
                ConsentAgreements[_agrNum].isExpired = false;

                ConsentAgreementList.push(_agrNum);

                ConsentContracts[_consentReqID].requestStatus = RequestStatus.Agreed;

                emit consentAgreementMade(_agrNum, _consentReqID, ConsentAgreements[_agrNum].isValid,
                                        ConsentAgreements[_agrNum].agreedBy );

                return (success = true);
    }


    function countConsentAgreement() view public returns(uint){
        return ConsentAgreementList.length;
    }

    function getConsentAgreementInfo(string memory _agrNum)
        view
        public
        returns(string memory, string memory, string memory, uint256, uint256, bool, bool)
        {
            return( ConsentAgreements[_agrNum].consentReqID,
                    ConsentAgreements[_agrNum].dSSignature,
                    ConsentAgreements[_agrNum].requesterSignature,
                    ConsentAgreements[_agrNum].startDateTime,
                    ConsentAgreements[_agrNum].endDateTime,
                    ConsentAgreements[_agrNum].isValid,
                    ConsentAgreements[_agrNum].isExpired);
        }

    function isConsentAgreementValid(string memory _agrNum) view public returns(bool){
         return (ConsentAgreements[_agrNum].isValid);
    }

    function isConsentAgreementExpired(string memory _agrNum) view public returns(bool){
         return (ConsentAgreements[_agrNum].isExpired);
    }

    function isExpiredConsentAgreement(string memory _agrNum, address approverID)
    public
    returns (bool success)
    {
        approverID = msg.sender;

        uint256 size = ConsentAgreementList.length;
       //require(ConsentAgreements[_agrNum].dataSubjectID == _dataSubjectID);
       //require(ConsentAgreements[_agrNum].dSSignature == _dSSignature);

        if(size>0){

            require(approverID != address(0), "ApproverID required !");

            for(uint i = size-1; i>=0; i--) {
                //require(ConsentAgreements[_agrNum].endDateTime <= now,
                //"Consent Agreement Licence has Expired !");
                //ConsentAgreementList[i];

                _agrNum = ConsentAgreementList[i];

                if(now >= ConsentAgreements[_agrNum].endDateTime){
                    ConsentAgreements[_agrNum].isExpired = true;
                    ConsentAgreements[_agrNum].isValid = false;
                }
                if(i==0){
                    break;
                }
            }
        }

        emit consentAgreementExpired(_agrNum, ConsentAgreements[_agrNum].isValid,
                                     ConsentAgreements[_agrNum].isExpired, approverID);
        return(success = true);
    }

    // Consent Agreement Update
    function updateConsentAgreement(
            string memory _agrNum,
            string memory _consentReqID,
            string memory _dSSignature,
            string memory _requesterSignature,
            //uint _startDateTime,
            uint256 _endDateTime )
            public
            returns(bool success)
            {
                ConsentAgreements[_agrNum].consentReqID = _consentReqID;
                ConsentAgreements[_agrNum].dSSignature = _dSSignature;
                ConsentAgreements[_agrNum].requesterSignature = _requesterSignature;
                //ConsentAgreements[_agrNum].startDateTime = _startDateTime;
                ConsentAgreements[_agrNum].endDateTime = _endDateTime;

                require((bytes(_dSSignature).length != 0) && (bytes(_requesterSignature).length != 0),
                        "Both signatures from DS and DC are required!");

                ConsentAgreements[_agrNum].isSigned = true;
                ConsentAgreements[_agrNum].isValid = true;
                ConsentAgreements[_agrNum].isExpired = false;

                ConsentContracts[_consentReqID].requestStatus = RequestStatus.Agreed;
                ConsentAgreements[_agrNum].lastUpdate = block.timestamp;
                ConsentAgreements[_agrNum].updatedBy = msg.sender;


                emit consentAgreementUpdated(_agrNum, ConsentAgreements[_agrNum].lastUpdate,
                                             ConsentAgreements[_agrNum].updatedBy);
               return (success = true);
    }

}
