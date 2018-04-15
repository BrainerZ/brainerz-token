pragma solidity ^0.4.18;

import "../common/CrowdSaleBase.sol";
import "./PresalePayload.sol";

contract SignedPresale is CrowdSaleBase {

    address public signerAddress;
    uint256 constant PRESALE_ALLOCATION = 600 * (10 ** 6) * (10 ** 18); //600,000,000 "BRNZ" like points

    /** A new server-side signer key was set to be effective */
    event SignerChanged(address signer);

    function SignedPresale(PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal)
                            CrowdSaleBase(FractionalERC20(0), _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) {

    }
    
  /**
   * Called from invest() to confirm if the curret investment does not break our cap rule.
   */
  function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
    if(tokenAmount > getTokensLeft()) {
      return true;
    } else {
      return false;
    }
  }
  
    /**
    * Get the amount of unsold tokens allocated to this contract;
    */
    function getTokensLeft() public constant returns (uint) {
        return PRESALE_ALLOCATION - tokensSold;
    }

    // Do nothing since this is presale there is no token
    // the token amount is saved in 'tokenAmountOf' mapping
    function assignTokens(address receiver, uint tokenAmount) internal {
    }

    function isCrowdsaleFull() public constant returns (bool) {
        return tokensSold == PRESALE_ALLOCATION;
}

}