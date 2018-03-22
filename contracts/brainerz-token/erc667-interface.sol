pragma solidity 0.4.21;
import "./erc20-interface.sol";
import "./basic-token.sol";
import "../misc/ownable.sol";

/// @title ERC Token Standard #677 Interface (https://github.com/ethereum/EIPs/issues/677)
contract ERC677Interface is ERC20Interface {
    function transferAndCall(address to, uint value, bytes data) public returns (bool ok);

    event TransferAndCall(address indexed from, address indexed to, uint value, bytes data);
}


/// @title Standard677Token implentation, base on https://github.com/ethereum/EIPs/issues/677

contract Standard677Token is ERC677Interface, BasicToken {

  /// @dev ERC223 safe token transfer from one address to another
  /// @param _to address the address which you want to transfer to.
  /// @param _value uint256 the amount of tokens to be transferred.
  /// @param _data bytes data that can be attached to the token transation
  function transferAndCall(address _to, uint _value, bytes _data) public returns (bool) {
    require(super.transfer(_to, _value)); // do a normal token transfer
    TransferAndCall(msg.sender, _to, _value, _data);
    //filtering if the target is a contract with bytecode inside it
    if (isContract(_to)) 
        return contractFallback(_to, _value, _data);
    return true;
  }

  /// @dev called when transaction target is a contract
  /// @param _to address the address which you want to transfer to.
  /// @param _value uint256 the amount of tokens to be transferred.
  /// @param _data bytes data that can be attached to the token transation
  function contractFallback(address _to, uint _value, bytes _data) private returns (bool) {
    ERC223Receiver receiver = ERC223Receiver(_to);
    require(receiver.tokenFallback(msg.sender, _value, _data));
    return true;
  }

  /// @dev check if the address is contract
  /// assemble the given address bytecode. If bytecode exists then the _addr is a contract.
  /// @param _addr address the address to check
  function isContract(address _addr) private constant returns (bool) {
    // retrieve the size of the code on target address, this needs assembly
    uint length;
    assembly { length := extcodesize(_addr) }
    return length > 0;
  }
}

/// @title ERC223Receiver Interface
/// @dev Based on the specs form: https://github.com/ethereum/EIPs/issues/223
contract ERC223Receiver {
    function tokenFallback(address _sender, uint _value, bytes _data) external returns (bool ok);
}