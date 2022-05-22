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
    collateral = IERC20(_collateral);
    stablecoin = IERC20(_stable);
    priceOracle = IOracle(_oracle);
    eth_usd_price_feed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
  }

  IOracle priceOracle;
  IERC20 collateral;
  IERC20 stablecoin;

  mapping(address => uint256) public bal;
  mapping(address => uint256) public debt;

  /*/ accounting logic /*/

  function deposit(uint256 _amount) public {
    require(collateral.transferFrom(msg.sender, address(this), _amount));
    bal[msg.sender] += _amount;
    emit collateralDeposited(_amount);
  }
  event collateralDeposited(uint256 amount);
  event collateralWithdraw(uint256 amount);
  event borrowed(uint256 amount);
  event repayed(uint256 amount);

  function withdraw(uint256 _amount) public {
    require(bal[msg.sender] >= _amount, "Withdraw exceeds balance");
    require(debt[msg.sender] == 0, "pay back debt");
    require(collateral.transfer(msg.sender, _amount), "transfer failed");
    bal[msg.sender] -= _amount;
    emit collateralWithdraw(_amount);
  }

  function borrow(uint256 _amount) external {
    require(calculateTotalUserValueUSD(msg.sender) >= _amount * 2, "exceeds ltv ratio");
    require(stablecoin.transfer(msg.sender, _amount), "transfer failed");
    debt[msg.sender] += _amount;
    emit borrowed(_amount);
  }

  function repay(uint256 _amount) external {
    require(_amount <= debt[msg.sender]);
    require(stablecoin.transferFrom(msg.sender, address(this), _amount));
    debt[msg.sender] -= _amount;
    emit repayed(_amount);
  }

  function liquidate(address _addr) external {
    require(calculateTotalUserValueUSD(_addr) <= debt[_addr] * 2);
    uint256 halfdebt = debt[_addr] / 2;
    uint256 fee = bal[_addr] / 10;
    require(stablecoin.transferFrom(msg.sender, address(this), halfdebt));
    require(collateral.transfer(msg.sender, fee));
    /*/ still need to transfer debt value of collateral to liquidator /*/
    debt[_addr] -= halfdebt;
    bal[_addr] -= fee;
  }
  /*/ view functions /*/

  function calculateCollateralValueUSD(address _addr) public view returns (uint256) {
    return bal[_addr] * getCollateralPriceUSD() / 10**18;
  }
  function calculateTotalUserValueUSD(address _addr) public view returns (uint256) {
    return calculateCollateralValueUSD(_addr) - debt[_addr];
  }
  function getCollateralPriceUSD() public view returns (uint256) {
    uint256 oraclePrice = getTwap();
    uint256 ethPrice = getEthUsd();
    return ethPrice.mul(oraclePrice) / 10**18;
  }

  function estimateMaxBorrow(address _addr) public view returns(uint256) {
    return calculateTotalUserValueUSD(_addr) / 2;
    /*/ this should be fixed /*/
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
