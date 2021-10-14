// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.6.0 <0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

/**
 * @title OurWallet
 * Stretching the concept of a multisignature wallet
 */
contract OurWallet {
    
    IERC20 public token;

    uint256 number;
    address public chairPerson;
    
    mapping(address => bool) public sandboxAddr;
     
    constructor(address _token) {
        chairPerson = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
        emit chairPersonSet(address(0), chairPerson);
        token = IERC20(_token);
    }     
    
    event chairPersonSet(address indexed oldChair, address indexed newChair);
     
    function store(uint256 num) public {
        //place holder for a transaction
        require(msg.sender == chairPerson, "Caller is not chair");
        number = num;
    }
    
     function storeChair(address _chairPerson) public {
        chairPerson = _chairPerson;
    }
    
    function enableSanboxAddr(address _sandboxAddr) public {
        sandboxAddr[_sandboxAddr] = true;
    }
    
    function disableSanboxAddr(address _sandboxAddr) public {
        sandboxAddr[_sandboxAddr] = false;
    }

    /**
     * @dev Return value 
     * @return value of 'number'
     */
    function retrieve() public view returns (uint256){
        return number;
    }
    
    function retrieveChairPerson() public view returns (address){
        return chairPerson;
    }
    
    function retrieveSanboxAddr(address _sandboxAddr) public view returns (bool){
        return sandboxAddr[_sandboxAddr];
    }
    
    
    function myBalance() public view returns (uint256){
        return token.balanceOf(msg.sender);
    }
}
