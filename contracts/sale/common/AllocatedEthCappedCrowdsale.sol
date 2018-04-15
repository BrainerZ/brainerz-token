/**
 * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
 *
 * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
 */

pragma solidity ^0.4.8;

import "./CrowdSaleBase.sol";

/**
 * ICO crowdsale contract that is capped by amout of ETH.
 *
 * - Tokens are dynamically created during the crowdsale
 *
 *
 */
contract AllocatedEthCappedCrowdsale is CrowdSaleBase {

  /* The party who holds the full token pool and has approve()'ed tokens for this CrowdSaleBase */
  address public beneficiary;

  function AllocatedEthCappedCrowdsale(address _token, PricingStrategy _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal)
                                      CrowdSaleBase(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal) {
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
   * We are sold out when our approve pool becomes empty.
   */
  function isCrowdsaleFull() public constant returns (bool) {
    return getTokensLeft() == 0;
  }

  /**
   * Get the amount of unsold tokens allocated to this contract;
   * 
   */
  function getTokensLeft() public constant returns (uint) {
    return token.allowance(owner, this);
  }

  /**
   * Transfer tokens from approve() pool to the buyer.
   *
   * Use approve() given to this CrowdSaleBase to distribute the tokens.
   */
  function assignTokens(address receiver, uint tokenAmount) internal {
    require(token.transferFrom(beneficiary, receiver, tokenAmount));
  }
}