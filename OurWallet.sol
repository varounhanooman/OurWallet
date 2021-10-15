// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.6.0 <0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

/**
 * @title OurWallet
 * Stretching the concept of a multisignature wallet
 */
contract OurWallet {
    
    IERC20 public token;

    uint256 public number;
    address public chairPerson;
    uint256 public proposalCount;
    uint256 public chairCount;
    
    mapping(address => bool) public sandboxAddr;
    
    mapping(address => uint256) public tokenCollectionForVotes;
     
    constructor(address _token) {
        chairPerson = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
        emit chairPersonSet(address(0), chairPerson);
        token = IERC20(_token);
        proposalCount = 0;
        chairCount = 0;
    }     
    
    event chairPersonSet(address indexed oldChair, address indexed newChair);
    
    event Response(bool success, bytes data);
    
    struct proposalAddr {
        address proposedAddr;
        uint forToggle;
        uint againstToggle;
    }
    
    proposalAddr[] public proposalArray;

    struct chairAddr {
        address proposedChair;
        uint forToggle;
        uint againstToggle;
    }
    
    chairAddr[] public chairArray;    
    
     
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
    
    //propose sandboxAddr
    function proposeSandboxAddrToggle(address _sandboxAddr) public {
        proposalArray.push(proposalAddr({
            proposedAddr: _sandboxAddr,
            forToggle: 0,
            againstToggle: 0
        }));
    }
    
    //propose chairPerson
    function proposeChairAddrToggle(address _chairAddr) public {
        chairArray.push(chairAddr({
            proposedChair: _chairAddr,
            forToggle: 0,
            againstToggle: 0
        }));
    }
    
    //tally & execute the vote
    function tallyExecuteSandboxVote(uint256 _proposalIndx) public {
        if (proposalArray[_proposalIndx].forToggle > proposalArray[_proposalIndx].againstToggle) {
            sandboxAddr[proposalArray[_proposalIndx].proposedAddr] = !sandboxAddr[proposalArray[_proposalIndx].proposedAddr];
            proposalCount++;
        }
    }
    
        //tally & execute the vote
    function tallyExecuteChairVote(uint256 _proposalIndx) public {
        if (chairArray[_proposalIndx].forToggle > chairArray[_proposalIndx].againstToggle) {
            chairPerson = chairArray[_proposalIndx].proposedChair;
            chairCount++;
        }
    }
    
    
    function giveContractTokensForSandboxVotes(uint256 _tokenAmt, uint256 _proposalIndx, bool _toggle) public {
        require((token.balanceOf(msg.sender)) > _tokenAmt, "Not enough tokens");
        safeTransferFrom(token, msg.sender, address(this), _tokenAmt);
        tokenCollectionForVotes[msg.sender] = _tokenAmt;
        if(_toggle == true){
            proposalArray[_proposalIndx].forToggle = _tokenAmt;
        }
        else{
            proposalArray[_proposalIndx].againstToggle = _tokenAmt;
        }
        
    }
    
    function giveContractTokensForChairVotes(uint256 _tokenAmt, uint256 _proposalIndx, bool _toggle) public {
        require((token.balanceOf(msg.sender)) > _tokenAmt, "Not enough tokens");
        safeTransferFrom(token, msg.sender, address(this), _tokenAmt);
        tokenCollectionForVotes[msg.sender] = _tokenAmt;
        if(_toggle == true){
            chairArray[_proposalIndx].forToggle = _tokenAmt;
        }
        else{
            chairArray[_proposalIndx].againstToggle = _tokenAmt;
        }
        
    }
    
    function withdrawVotingTokens() public {
        require( tokenCollectionForVotes[msg.sender] > 0, "No tokens to withdraw");
        token.transfer( msg.sender, tokenCollectionForVotes[msg.sender]);
    }
    
    function safeTransferFrom(IERC20 _token, address _sender, address _recipient, uint _amount) private {
        bool sent = _token.transferFrom(_sender, _recipient, _amount);
        require(sent, "Token transfer failed");
    }
    
    function chairAction(address payable _addr, string memory _funcName, string memory _param1, uint _param2) public payable {
        require(chairPerson == msg.sender, "You are not the Chair Person");
        require(sandboxAddr[_addr], "This address is not in the approved sandbox"); // needs to be an apporved address
        // You can send ether and specify a custom gas amount
        (bool success, bytes memory data) = _addr.call{value: msg.value, gas: 5000}(abi.encodeWithSignature(_funcName, _param1, _param2));

        emit Response(success, data);
    }

    function retrieveProposalCount() public view returns (uint256){

        return proposalCount;
        
    }
    
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
