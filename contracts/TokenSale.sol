pragma solidity ^0.4.8;

import './SafeMath.sol';

contract TokenSale {
  using SafeMath for uint;

  uint public fundingLimit;
  uint public startTime;
  address public recipient;

  event Purchase(address purchaser, uint paid, uint received);

  function TokenSale(
    address _recipient,
    uint _limit,
    uint _start
  ) {
    fundingLimit = _limit;
    recipient = _recipient;
    startTime = _start;
  }

  function phaseOneEnd()
  constant returns (uint) {
    return startTime + 1 weeks;
  }

  function phaseTwoEnd()
  constant returns (uint) {
    return startTime + 2 weeks;
  }

  function endTime()
  constant returns (uint) {
    return startTime + 4 weeks;
  }

  function ()
  payable ensureStarted {
    if (recipient.send(msg.value)) {
      Purchase(msg.sender, msg.value, amountReceived());
    }
  }


  // PRIVATE

  function amountReceived()
  private returns (uint) {
    if (block.timestamp <= phaseOneEnd()) {
      return msg.value.div(10**15);
    } else if (block.timestamp <= phaseTwoEnd()) {
      return msg.value.times(75).div(10**17);
    } else {
      return msg.value.times(50).div(10**17);
    }
  }


  // MODIFIERS

  modifier ensureStarted() {
    if (block.timestamp < startTime || block.timestamp > endTime()) {
      throw;
    } else {
      _;
    }
  }

}