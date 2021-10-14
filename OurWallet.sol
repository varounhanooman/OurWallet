// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title OurWallet
 * Stretching the concept of a multisignature wallet
 */
contract OurWallet {

    uint256 number;
    address public chairPerson;
    
    mapping(address => bool) public sandboxAddr;
     
    constructor() {
        chairPerson = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
        emit chairPersonSet(address(0), chairPerson);
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
    
    function storeSanboxAddr(address _sandboxAddr) public {
        sandboxAddr[_sandboxAddr] = true;
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
}
