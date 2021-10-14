// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title OurWallet
 * Stretching the concept of a multisignature wallet
 */
contract OurWallet {

    uint256 number;
    address chairPerson;

    /**
     * @dev Store value in variable
     * @param num value to store
     */
    function store(uint256 num) public {
        number = num;
    }
    
     function storeChair(address _chairPerson) public {
        chairPerson = _chairPerson;
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
}
