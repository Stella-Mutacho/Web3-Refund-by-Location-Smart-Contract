// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

contract Refund {
    address owner;          //the creator of the contract
    int256 private constant RESOLUTION = 1000000000000000;  //to be used as the denominator when calculating the coordinates
    uint256 private constant RADIUS =100;         //the maximum possible allowed radius around the exact location where the employee is expected to be
    address[] employee_list;      //A list of employee. Employees are identified by their public key addresses

    mapping(address => Employee_Info) public contractInfo;

    struct Coordinate {
        uint256 lat;
        uint256 long;
    }                   //represents a location on a map

    struct Employee_Info{
        Coordinate expected_location;       //location where the employee is expected to checkin
        uint budget;                        //the amount the employee is supposed to be reimbursed if he/she is compliant with the contract
        bool isCompliant;        //true if the employee is compliant with the contract
        uint count;             //keeps track of number of times the employee has been checked to comply with the contract
    }
    /*
    This Function is the constructor which registers the creator of the contract.
    */
    constructor() {
        owner = msg.sender;
    }
    /*
    Function that terminates the contract if the employer initializes end of the contract
    */
    function kill() public {
      if(msg.sender == owner) selfdestruct(payable(owner));
    }
/**
*Function to check if employee is in the list of employees
*@param empAddress Public key of the employee
*@return true if employee is in the list and false otherwise
*/
    function checkEmployeeExistance(address empAddress) private view returns(bool){ 
    for(uint256 i = 0; i < employee_list.length; i++){ 
        if(employee_list[i] == empAddress)
        return true;  
    }        
    return false;
    }

/**
*Function to add new employee details in the list
*@param id Public key of the employee
*@param lat Latitude of employee location on map
*@param lon longitude of employee location on map
*@param budget amount to be reimbursed by the Employer
*/
    function addEmployee(address id, uint256 lat, uint256 lon, uint8 budget) public  {
    require(!checkEmployeeExistance(id));
    contractInfo[id].expected_location = Coordinate(lat, lon);
    contractInfo[id].budget = budget;
    contractInfo[id].isCompliant = true;
    employee_list.push(id);
    }
/**
 *Calculates the square root of an integer
 *@param x The integer to get it square root
 *@return y the square root of the integer
 */
    function sqrt(uint x) private pure returns (uint y) {
    uint z = (x + 1) / 2;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    } 

    function getDistance(uint256 lat, uint256 lon, address _employeeAddress) private view returns(uint256) {
        uint256 x = lat - contractInfo[_employeeAddress].expected_location.lat;
            uint256 y = lon - contractInfo[_employeeAddress].expected_location.long;
            uint256 radius = sqrt(x**2 + y**2);
            return radius;
    }
    function checkDistance(uint256 lat, uint256 lon) public {
        uint256 new_radius = getDistance(lat, lon, msg.sender);
        if(new_radius < RADIUS){
            contractInfo[msg.sender].isCompliant = true;
        }else{
            contractInfo[msg.sender].isCompliant = false;
        }
    }
    function reimburse(address payable _to) public {
            require(checkEmployeeExistance(_to));
            require(contractInfo[_to].isCompliant == true);
            bool sent = _to.send(contractInfo[_to].budget);
            require(sent, "Failed reimburse the employee!!");
            contractInfo[_to].isCompliant=false;
        }
    

    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    event Transfer(address indexed from, address indexed to, uint tokens);

    mapping(address => uint256) balances;
    mapping(address => mapping (address => uint256)) allowed;
    
}

    
    
    