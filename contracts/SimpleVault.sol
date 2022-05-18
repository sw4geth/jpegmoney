// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/utils/math/SafeCast.sol";
import "./IOracle.sol";

contract SimpleVault {
  using SafeCast for int256;
  AggregatorV3Interface internal eth_usd_price_feed;

  constructor(address _collateral, address _stable, address _oracle){
    IERC20 collateral = IERC20(_collateral);
    address token = _collateral;
    IERC20 stablecoin = IERC20(_stable);
    IOracle priceOracle = IOracle(_oracle);
    eth_usd_price_feed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
  }

  IOracle priceOracle;
  IERC20 collateral;
  IERC20 stablecoin;
  uint oraclePrice;
  uint ethPrice;
  address token;

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
    require(bal[msg.sender] - debt[msg.sender] >= _amount, "Pay up homeboy!");
    collateral.transferFrom(address(this), msg.sender, _amount);
    bal[msg.sender] -= _amount;
  }

  /*/ view functions /*/

  function getBalance(address _addr) public view returns (uint256){
    return bal[_addr];
  }
  function getDebt(address _addr) public view returns (uint256){
    return debt[_addr];
  }

  /*/ oracle functions /*/

  /*/ get collateral price TWAP in eth from Uniswap factory router /*/
  function getCollateralPrice() external {
    priceOracle.update();
    oraclePrice = priceOracle.consult(token, 1000000000000000000);
  }
  /*/ chainlink feed to get eth price in usd /*/
  function getEthUsd() public view returns (uint) {
        (
            , int price, , ,
        ) = eth_usd_price_feed.latestRoundData();

        return price.toUint256();
    }
    function setEth() external{
      ethPrice = getEthUsd();
    }
}
