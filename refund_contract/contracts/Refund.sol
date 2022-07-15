// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

contract Refund {
    address employer;          //the owner of the contract
    struct employee_location{
        uint longitude;
        uint latitude;
    }                       //last location of the employee
    bool isCompliant;
    uint amount;            //amount to transfer to the employee if compliant with the contract
    uint count;             //keeps track of number of times the employee has been checked to comply with the contract

    // This is the constructor which registers the
    // creator and the assigned name.
    constructor() {
        // See the next section for details.
        employer = msg.sender;
    }

    //get location


    // 
}