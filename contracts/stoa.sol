// SPDX-License-Identifier: MIT

import "./MorphoCompoundSupplier.sol";

pragma solidity ^0.8.7;

contract stoa {
    MorphoCompoundSupplier public assetSupply;

    address public constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

    function supply(address _token, uint256 amount) public {
        if (_token == WETH) {
            assetSupply.supplyETH(amount);
        }
    }
}
