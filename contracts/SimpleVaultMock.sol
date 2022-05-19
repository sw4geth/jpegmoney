// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract SimpleVaultMock {
  using SafeMath for uint256;
  mapping(address => uint256) public bal;
  mapping(address => uint256) public debt;

  /*/lets hardcode the prices/*/
  uint256 ethPrice = 2000000000000000000000; /*/ 2000 usd /*/
  uint256 collateralPrice = 500000000000000000; /*/ .5 ether /*/
  uint256 stablePrice = 1000000000000000000; /*/ 1 usd /*/
  uint256 ltvRatio = 1000000000000000000; /*/ 1, need to figure out this math lol/*/

  /*/ accounting logic /*/

  function deposit(uint256 _amount) external {
    bal[msg.sender] += _amount;
  }

  function borrow(uint256 _amount) external {
    require(bal[msg.sender].mul(collateralPrice).mul(ethPrice).sub(debt[msg.sender]) >= _amount, "Cannot borrow more than balance");
    debt[msg.sender] += _amount;
  }

  function repay(uint256 _amount) external {
    debt[msg.sender] -= _amount;
  }

  function withdraw(uint256 _amount) external {
    require(quickPrice(bal[msg.sender]) - debt[msg.sender] >= _amount, "Nope");
    bal[msg.sender] -= _amount;
  }

  /*/ view functions /*/


  function getCollateralValue(address _addr) public view returns (uint256){
    return bal[_addr].mul(collateralPrice).mul(ethPrice).div(stablePrice);
  }

  function quickPrice(uint256 _amount) public view returns (uint256){
    return _amount.mul(collateralPrice).mul(ethPrice).div(stablePrice);
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

  function liquidate(address _addr) external {
      require(bal[_addr].mul(collateralPrice).div(ltvRatio) <= 1000000000000000000, "Loan solvent");
      /*/ calculate amount to liquidate and fee /*/
  }

}
