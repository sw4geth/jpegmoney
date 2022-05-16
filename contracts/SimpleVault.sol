// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
contract SimpleVault {

  constructor(address _collateral, address _stable){
    IERC20 collateral = IERC20(_collateral);
    IERC20 stablecoin = IERC20(_stable);
  }

  IERC20 collateral;
  IERC20 stablecoin;
  mapping(address => uint256) public bal;
  mapping(address => uint256) public debt;

  /*/ accounting logic /*/

  function deposit(uint256 _amount) external {
    collateral.transferFrom(msg.sender, address(this), _amount);
    bal[msg.sender] += _amount;
  }

  function borrow(uint256 _amount) external {
    require(bal[msg.sender] >= _amount, "Cannot borrow more than balance");
    debt[msg.sender] += _amount;
    stablecoin.transferFrom(address(this), msg.sender, _amount);
  }

  function repay(uint256 _amount) external {
    stablecoin.transferFrom(msg.sender, address(this), _amount);
    debt[msg.sender] -= _amount;
  }

  function withdraw(uint256 _amount) external {
    require(bal[msg.sender] - debt[msg.sender] <= _amount, "Pay up homeboy!");
    collateral.transferFrom(address(this), msg.sender, _amount);
  }

  /*/ view functions /*/

  function getBalance(address _addr) public view returns (uint256){
    return bal[_addr];
  }
  function getDebt(address _addr) public view returns (uint256){
    return debt[_addr];
  }

}
