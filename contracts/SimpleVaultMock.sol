// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract SimpleVault {
  using SafeMath for uint256;
  mapping(address => uint256) public bal;
  mapping(address => uint256) public debt;

  /*/lets hardcode the prices/*/
  uint256 ethPrice = 2000000000000000000000; /*/ 2000 usd /*/
  uint256 collateralPrice = 500000000000000000; /*/ .5 ether /*/
  uint256 stablePrice = 1000000000000000000; /*/ 1 usd /*/

  /*/ accounting logic /*/

  function deposit(uint256 _amount) external {
    bal[msg.sender] += _amount;
  }

  function borrow(uint256 _amount) external {
    require(bal[msg.sender].mul(collateralPrice).mul(ethPrice).div(stablePrice).sub(debt[msg.sender]) >= _amount, "Cannot borrow more than balance");
    debt[msg.sender] += _amount;
  }

  function repay(uint256 _amount) external {
    debt[msg.sender] -= _amount;
  }

  function withdraw(uint256 _amount) external {
    require(bal[msg.sender] - debt[msg.sender] >= _amount, "Pay up homeboy!");
    bal[msg.sender] -= _amount;
  }

  /*/ view functions /*/
  function getCollateralValue(address _addr) public view returns (uint256){
    return bal[_addr].mul(collateralPrice).mul(ethPrice).div(stablePrice);
  }

  function getWorth(address _addr) public view returns (uint256) {
      getCollateralValue(_addr).sub(debt[_addr]);
  }

  function getBalance(address _addr) public view returns (uint256){
    return bal[_addr];
  }

  function getDebt(address _addr) public view returns (uint256){
    return debt[_addr];
  }

}
