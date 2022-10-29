// SPDX-License-Identifier: GNU AGPLv3
pragma solidity ^0.8.16;

import {IMorpho} from "./interfaces/IMorpho.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IWETH9 {
    function deposit() external payable;
}

contract MorphoCompoundSupplier {
    address public constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public constant CETH = 0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5;
    address public constant MORPHO = 0x8888882f8f843896699869179fB6E4f7e3B58888;

    function _supplyERC20(
        address _cToken,
        address _underlying,
        uint256 _amount
    ) internal {
        IERC20(_underlying).approve(MORPHO, _amount);
        IMorpho(MORPHO).supply(
            _cToken,
            address(this), // the address of the user you want to supply on behalf of
            _amount
        );
    }

    function supplyETH(uint256 amount) public payable {
        // first wrap ETH into WETH
        IWETH9(WETH).deposit{value: amount}();

        _supplyERC20(
            CETH, // the WETH market, represented by the cETH ERC20 token
            WETH,
            msg.value
        );
    }
}
