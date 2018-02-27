pragma solidity ^0.4.18;

// Taken from: 
contract Owneable {
    address public owner; // should it preferable by internal?
    address public newOwner;

    event OwnershipTransferred(address indexed _from, address indexed _to);


    function Owneable() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }
    function acceptOwnership() public {
        require(msg.sender == newOwner);
        OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}