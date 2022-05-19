// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/utils/math/SafeCast.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./IOracle.sol";

contract SimpleVault {
  using SafeCast for int256;
  using SafeMath for uint256;
  AggregatorV3Interface internal eth_usd_price_feed;

  constructor(address _collateral, address _stable, address _oracle){
    IERC20 collateral = IERC20(_collateral);
    IERC20 stablecoin = IERC20(_stable);
    priceOracle = IOracle(_oracle);
    eth_usd_price_feed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
  }

  IOracle priceOracle;
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
    require(calculateCollateralValueUSD(msg.sender) - debt[msg.sender] / 2 >= _amount, "Whoah there bud!");
    debt[msg.sender] += _amount;
    stablecoin.transferFrom(address(this), msg.sender, _amount);
  }

  function repay(uint256 _amount) external {
    stablecoin.transferFrom(msg.sender, address(this), _amount);
    debt[msg.sender] -= _amount;
  }

  function withdraw(uint256 _amount) external {
    require(calculateCollateralValueUSD(msg.sender) - debt[msg.sender] / 2 >= _amount, "Whoah there bud!");
    bal[msg.sender] -= _amount;
    collateral.transferFrom(address(this), msg.sender, _amount);
  }

  /*/ view functions /*/

  function getBalance(address _addr) public view returns (uint256){
    return bal[_addr];
  }
  function getDebt(address _addr) public view returns (uint256){
    return debt[_addr];
  }

  function calculateCollateralValueUSD(address _addr) public view returns (uint256) {
    return bal[_addr] * getCollateralPriceUSD();
  }

  function getCollateralPriceUSD() public view returns (uint256) {
    uint256 oraclePrice = getTwap();
    uint256 ethPrice = getEthUsd();
    return ethPrice.mul(oraclePrice) / 10**18;
  }

  /*/ oracle functions /*/

  /*/ get collateral price TWAP in eth from Uniswap factory router /*/
  function updateTwap() external {
    priceOracle.update();
  }
  function getTwap() public view returns (uint256) {
    return priceOracle.consult(0x286AaF440879dBeAF6AFec6df1f9bfC907101f9D, 1000000000000000000);
  }

  /*/ chainlink feed to get eth price in usd /*/
  function getEthUsd() public view returns (uint256) {
        (
            , int price, , ,
        ) = eth_usd_price_feed.latestRoundData();

        return price.toUint256() * 10**10;
    }

}
