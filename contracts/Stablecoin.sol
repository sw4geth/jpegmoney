//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract JPEGusd is ERC20, Ownable {
    constructor() ERC20("JPEG USD", "JPGUSD"){
    }

    function issueToken(address receiver, uint256 amount) external onlyOwner() {
        _mint(receiver, amount);
    }
}
