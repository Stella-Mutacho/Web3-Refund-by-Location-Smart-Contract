// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

contract Refund{
    address public employer;
    address public employee;
    function Refund() public {
      employer = msg.sender;
   }
   function kill() public {
      if(msg.sender == employer) selfdestruct(employer);
   }
}
}