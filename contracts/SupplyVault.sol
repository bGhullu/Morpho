// SPDX-License-Identifier: GNU AGPLv3
pragma solidity 0.8.13;

import {ISupplyVault} from "./interfaces/ISupplyVault.sol";
import {IMorpho} from "./interfaces/IMorpho.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {ERC20, SafeTransferLib} from "@rari-capital/solmate/src/utils/SafeTransferLib.sol";
import {FixedPointMathLib} from "@rari-capital/solmate/src/utils/FixedPointMathLib.sol";
import {SafeCastLib} from "@rari-capital/solmate/src/utils/SafeCastLib.sol";
import {ERC4626UpgradeableSafe, ERC20Upgradeable} from "./ERC4626UpgradeableSafe.sol";
import {CompoundMath} from "./interfaces/CompoundMath.sol";
import {Types} from "./interfaces/Types.sol";

// import {SupplyVaultBase} from "./SupplyVaultBase.sol";

/// @title SupplyVault.
/// @author Morpho Labs.
/// @custom:contact security@morpho.xyz
/// @notice ERC4626-upgradeable Tokenized Vault abstract implementation for Morpho-Compound.

contract SupplyVault is ERC4626UpgradeableSafe, OwnableUpgradeable {
    using CompoundMath for uint256;
    using SafeTransferLib for ERC20;

    /// ERRORS ///

    /// @notice Thrown when the zero address is passed as input.
    error ZeroAddress();

    /// STORAGE ///

    IMorpho public immutable morpho; // The main Morpho contract.
    address public immutable wEth; // The address of WETH token.
    ERC20 public immutable comp; // The COMP token.

    address public poolToken; // The pool token corresponding to the market to supply to through this vault.

    /// CONSTRUCTOR ///

    /// @dev Initializes network-wide immutables.
    /// @param _morpho The address of the main Morpho contract.

    constructor(address _morpho) {
        morpho = IMorpho(_morpho);
        wEth = morpho.wEth();
        comp = ERC20(morpho.comptroller().getCompAddress());
    }

    function totalAssets() public view override returns (uint256) {
        address poolTokenMem = poolToken;
        Types.SupplyBalance memory supplyBalance = morpho.supplyBalanceInOf(
            poolTokenMem,
            address(this)
        );

        return
            supplyBalance.onPool.mul(morpho.lastPoolIndexes(poolTokenMem).lastSupplyPoolIndex) +
            supplyBalance.inP2P.mul(morpho.p2pSupplyIndex(poolTokenMem));
    }

    function deposit(uint256 assets, address receiver) public virtual override returns (uint256) {
        // Update the indexes to get the most up-to-date total assets balance.
        morpho.updateP2PIndexes(poolToken);
        return super.deposit(assets, receiver);
    }

    function mint(uint256 shares, address receiver) public virtual override returns (uint256) {
        // Update the indexes to get the most up-to-date total assets balance.
        morpho.updateP2PIndexes(poolToken);
        return super.mint(shares, receiver);
    }

    function withdraw(
        uint256 assets,
        address receiver,
        address owner
    ) public virtual override returns (uint256) {
        // Update the indexes to get the most up-to-date total assets balance.
        morpho.updateP2PIndexes(poolToken);
        return super.withdraw(assets, receiver, owner);
    }

    function redeem(
        uint256 shares,
        address receiver,
        address owner
    ) public virtual override returns (uint256) {
        // Update the indexes to get the most up-to-date total assets balance.
        morpho.updateP2PIndexes(poolToken);
        return super.redeem(shares, receiver, owner);
    }
}
