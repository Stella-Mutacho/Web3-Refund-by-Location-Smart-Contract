// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

contract Refund {
    address employer;          //the owner of the contract
    uint256 private constant RESOLUTION = 1000000000000000; //To be used when calculating coordinates 
    

    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    event Transfer(address indexed from, address indexed to, uint tokens);

    mapping(address => uint256) balances;
    mapping(address => mapping (address => uint256)) allowed;
    
    struct Coordinates{   //representation of the location on a map
        int longitude; 
        int latitude;    
    }                      

    struct Employee_info{
        address employee_address;   //Public address of the employee
        Coordinates expected_location; //The exact area the employee should be around
        bool isCompliant;     //True is the employee is with the range 
        uint amount;            //amount to transfer to the employee if compliant with the contract
        uint count;
        int256 radius;             //keeps track of number of times the employee has been checked to comply with the contract
    }
    Employee_info[] employee_list; //list of employees with their details

    /*
    This Function is the constructor which registers the creator of the contract.
    */
    constructor() {
        employer = msg.sender;
    }
    /*
    Function that terminates the contract if the employer initializes end of the contract
    */
    function kill() public {
      if(msg.sender == employer) selfdestruct(payable(employer));
    }
    function abs(int x) private pure returns (int) {
    return x >= 0 ? x : -x;
    }
/**
*Function to check if employee is in the list of employees
*@param empAddress Public key of the employee
*@return true if employee is in the list and false otherwise
*/
    function checkEmployeeExistance(address empAddress) private view returns(bool){
        for(uint256 i = 0; i < employee_list.length; i++){
            if(employee_list[i].employee_address == empAddress)
            return true;
            }
            return false;
            }
/**
*Function to add new employee details in the list
*@param id Public key of the employee
*@param lat Latitude of employee location on map
*@param lon longitude of employee location on map
*@param rad distance within which employee is allowed by the employer 
*@param budget amount to be reimbursed by the Employer
*/
    function add_employee(address id, int256 lat, int256 lon, int256 rad, uint8 budget) public{
        require(!checkEmployeeExistance(id));
        Coordinates memory expected_loc = Coordinates(lat, lon);
        Employee_info memory employee = Employee_info(id, expected_loc, true, budget,  0, rad);
        employee_list.push(employee);
    }
    
    function sqrt(int256 input) private pure returns (int256 output) {
        int256 interim = (input + 1) / 2;
        output = input;
        while (interim < output) {
            output = interim;
            interim = (input / output * 2) / 2;
        }
    }
    function calculate_radius(int256 lat, int256 lon, Employee_info memory _employee) private pure returns(int256) {
        int256 radius = 0;
        int256 x = lat - _employee.expected_location.latitude;
        int256 y = lon - _employee.expected_location.longitude;
        radius = sqrt(x**2 + y**2);
        return radius;
    }
    function check_position(int256 lat, int256 lon) public {
        int256 new_radius = calculate_radius(lat, lon, msg.sender);
        if(new_radius < contractInfo[msg.sender].radius){
            employeeInfo[msg.sender].status = true;
        }else{
            employeeInfo[msg.sender].status = false;
        }
    }

    //Function to enforce the contract only if the employees location is within a given radius
    // function get_location(Employee memory _employee)public returns(mapping(address=>Coordinates) employee_location)
   


    //Function to transfer money from employer to employee 
   

}