// SPDX-License-Identifier: MIT
pragma solidity 0.8.8;

struct Official{
     string name;
    uint lgaCode;
    address officialAddr;
    bool isActive;
}

struct VoteZone{
    string lga;
    string state;
    uint stateCode;
    uint lgaCode;
}
