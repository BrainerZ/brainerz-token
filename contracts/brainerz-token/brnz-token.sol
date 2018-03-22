pragma solidity 0.4.21;

import "../misc/safe-math.sol";
import "../misc/ownable.sol";
import "./erc20-interface.sol";
import "./erc667-interface.sol";

contract BrainerzToken is Ownable, Standard677Token {

    // Public variables of the token
    string public name = "BrainerZ Token";
    string public symbol = "BRNZ";
    uint8 public decimals = 18;

    uint256 public totalSupply;

    // This creates an array with all balances
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;
    
    // States whether token transfers is allowed or not.
    // Used during token sale.
    bool public isTransferable = false;

    event TokensTransferable();

    modifier transferable() {
        require(msg.sender == owner || isTransferable);
        _;
    }
    // This notifies clients about the amount burnt
    event Burn(address indexed from, uint256 value);
    

    /**
     * Constructor function
     *
     * Initializes contract with initial supply tokens to the creator of the contract
     */
    function BrainerzToken( uint256 initialSupply ) public {
        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
    }

    /// @dev start transferable mode.
    function makeTokensTransferable() external onlyOwner {
        if (isTransferable) {
            return;
        }

        isTransferable = true;

        TokensTransferable();
    }

    /// @dev Same ERC20 behavior, but reverts if not transferable.
    /// @param _spender address The address which will spend the funds.
    /// @param _value uint256 The amount of tokens to be spent.
    function approve(address _spender, uint256 _value) public transferable returns (bool) {
        return super.approve(_spender, _value);
    }

    /// @dev Same ERC20 behavior, but reverts if not transferable.
    /// @param _to address The address to transfer to.
    /// @param _value uint256 The amount to be transferred.
    function transfer(address _to, uint256 _value) public transferable returns (bool) {
        return super.transfer(_to, _value);
    }

    /// @dev Same ERC20 behavior, but reverts if not transferable.
    /// @param _from address The address to send tokens from.
    /// @param _to address The address to transfer to.
    /// @param _value uint256 the amount of tokens to be transferred.
    function transferFrom(address _from, address _to, uint256 _value) public transferable returns (bool) {
        return super.transferFrom(_from, _to, _value);
    }

    /// @dev Same ERC677 behavior, but reverts if not transferable.
    /// @param _to address The address to transfer to.
    /// @param _value uint256 The amount to be transferred.
    /// @param _data bytes data to send to receiver if it is a contract.
    function transferAndCall(address _to, uint _value, bytes _data) public transferable returns (bool success) {
      return super.transferAndCall(_to, _value, _data);
    }

    /**
     * Destroy tokens
     *
     * Remove `_value` tokens from the system irreversibly
     *
     * @param _value the amount of money to burn
     */
    function burn(uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
        balanceOf[msg.sender] -= _value;            // Subtract from the sender
        totalSupply -= _value;                      // Updates totalSupply
        Burn(msg.sender, _value);
        return true;
    }

    /**
     * Destroy tokens from other account
     *
     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
     *
     * @param _from the address of the sender
     * @param _value the amount of money to burn
     */
    function burnFrom(address _from, uint256 _value) public returns (bool success) {
        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
        require(_value <= allowance[_from][msg.sender]);    // Check allowance
        balanceOf[_from] -= _value;                         // Subtract from the targeted balance
        allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
        totalSupply -= _value;                              // Update totalSupply
        Burn(_from, _value);
        return true;
    }

    // Don't accept ETH
    // -----------------
    function () public payable {
        revert();
    }


    // Owner can transfer out any accidentally sent ERC20 tokens
    // ----------------------------------------------------------
    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
        return ERC20Interface(tokenAddress).transfer(owner, tokens);
    }
}