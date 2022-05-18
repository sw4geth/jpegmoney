// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IOracle {
  function update() external;
  function consult() external view returns(uint);
}
