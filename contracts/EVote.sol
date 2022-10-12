// SPDX-License-Identifier: MIT
pragma solidity 0.8.8;

import './structs/Official.sol';
// user can register base on state and  country
// create Applicant  only owner
//  set vote day
//  set accredicted vote location
//  user can watch vote as e edy go
// https://medium.com/blockcentric/ethereum-dapp-portfolio-ideas-21e1aac6dc52
//https://www.ethhole.com/challenge

contract EVote{
    
    address private ownerAddr;
    address[] accredictedOfficialAddr; // hold all official address
    mapping(address=>Official) accredictedOfficialDetails; 
    mapping(uint=>VoteZone) accredictedZone;
    VoteZone[] zones;
    mapping(uint=>string) statesMap;
    string[] states;
    
    modifier isOwnerMod{
        require(ownerAddr != msg.sender,"you can not add official");
        _;
    }

    modifier checkLocalGovtCode(uint code){
        require(accredictedZone[code].lgaCode > 0 , "local government already exist");
        _;
    }

    modifier checkState(uint stateCode){
        require(bytes(statesMap[stateCode]).length < 0, "state does not exist");
        _;
    }
    
    constructor (){
        ownerAddr = msg.sender;
    }

    function getOwner() external view returns (address){
        return ownerAddr;
    }

    function getStates() external view returns(string[] memory) {
        return states;
    }

    function addState(string calldata stateName, uint  stateCode) external isOwnerMod{
        require(bytes(statesMap[stateCode]).length > 0, "state already exist");
        statesMap[stateCode] = stateName;
        states.push(stateName);
    }

    function addLocalGovernment(string calldata lga, uint lgaCode, uint stateCode)  external isOwnerMod checkState(stateCode) checkLocalGovtCode(lgaCode) returns (VoteZone memory _zone){
        string memory _stateName = statesMap[stateCode];
        _zone = VoteZone(lga,_stateName,stateCode,lgaCode);
        accredictedZone[lgaCode] = _zone;
        zones.push(_zone);
    }

    function getLocalGovernment() external view returns (VoteZone[] memory){
       return zones; 
    }

    function accredictedNewOfficial(address officialAddress, string calldata officialName, uint lgaCode) external isOwnerMod{
        require(accredictedZone[lgaCode].lgaCode == 0 , "local government does not exist");
        accredictedOfficialAddr.push(officialAddress);
        accredictedOfficialDetails[officialAddress] = Official({
         name: officialName, lgaCode: lgaCode,
        officialAddr: officialAddress,
        isActive: true});
        //check for the code that match the selec
    }

    



}