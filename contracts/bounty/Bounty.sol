pragma solidity ^0.4.18;

import "../misc/SafeMath.sol";
import "../misc/ownable.sol";
import "../token/Erc20.sol";

contract Bounty is Ownable {
	
	using SafeMath for uint256;

	ERC20Interface token ;
	mapping (address => uint) balanceOf;
	uint TimeOut = 4 * 60 * 24 * 180;
	uint lock  = block.number + TimeOut;

	event CreditAdded(address client, uint creditAdded, uint userNewBalance);
	event BountyWithdraw(address client, uint withdrawAmount);


     /// @dev Change the ERC20 address
    /// @param _tokenAddress address the address of the new erc20 token.
    function setToken(ERC20Interface _tokenAddress) onlyOwner {
        token = ERC20Interface(_tokenAddress);
    }

	/// @dev add credit to specific user and
    /// setting the lock time for withdraw
    /// @param user address the address of the user
    /// @param credit uint the amount of credit to add
    /// @param lockTime uint the time in block to lock the credit for withdraw
    function addCredit(address user, uint credit, uint lockTime) onlyOwner {
        balanceOf[user] = balanceOf[user].add(credit);
        CreditAdded(user, credit, balanceOf[user]);
    }



    /// @dev add credit to specific array of users
    ///  and setting the lock time for withdraw
    /// @param users address[] the addresses of the users
    /// @param credits uint[] the amounts of credit to add
    /// @param lockTime uint the time in block to lock the credit for withdraw
    function bulkCredits(address[] users, uint[] credits, uint lockTime) onlyOwner {
        require(users.length == credits.length);
        for (uint i = 0; i < users.length; i++) {
            addCredit(users[i], credits[i], lockTime);
        }
    }


    // @dev for user to claim bounty
    function getBounty() {
    	uint balance = balanceOf[msg.sender];
    	if (balance > 0 && block.number < lock) {
    		balanceOf[msg.sender] = 0;
    		require(token.transfer(msg.sender, balance));
    		BountyWithdraw(msg.sender,balance);
    	}

    }

    // @dev after claim period is over
    function drain(uint amount) onlyOwner {
    	if (block.number > lock) {
    		token.transfer(owner, amount);
    	}
    }
}