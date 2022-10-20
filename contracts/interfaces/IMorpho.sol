// SPDX-License-Identifier: GNU AGPLv3
pragma solidity ^0.8.0;

import {IComptroller} from "@thenextblock/hardhat-compound/dist/contracts/compound/Comptroller.sol";

interface IMorpho {
    function isClaimRewardsPaused() external view returns (bool);

    function maxSortedUsers() external view returns (uint256);

    function dustThreshold() external view returns (uint256);

    function enteredMarkets(address) external view returns (address);

    function marketsCreated() external view returns (address[] memory);

    function p2pDisabled(address) external view returns (bool);

    function p2pSupplyIndex(address) external view returns (uint256);

    function p2pBorrowIndex(address) external view returns (uint256);

    function treasuryVault() external view returns (address);

    function comptroller() external view returns (IComptroller);

    function cEth() external view returns (address);

    function wEth() external view returns (address);

    function updateP2PIndexes(address _poolTokenAddress) external;

    function getEnteredMarkets(address _user)
        external
        view
        returns (address[] memory enteredMarkets_);

    function getAllMarkets() external view returns (address[] memory marketsCreated_);

    function supply(
        address _poolTokenAddress,
        address _onBehalf,
        uint256 _amount
    ) external;

    function supply(
        address _poolTokenAddress,
        address _onBehalf,
        uint256 _amount,
        uint256 _maxGasForMatching
    ) external;

    function borrow(address _poolTokenAddress, uint256 _amount) external;

    function borrow(
        address _poolTokenAddress,
        uint256 _amount,
        uint256 _maxGasForMatching
    ) external;

    function withdraw(address _poolTokenAddress, uint256 _amount) external;

    function repay(
        address _poolTokenAddress,
        address _onBehalf,
        uint256 _amount
    ) external;

    function liquidate(
        address _poolTokenBorrowedAddress,
        address _poolTokenCollateralAddress,
        address _borrower,
        uint256 _amount
    ) external;

    function claimRewards(address[] calldata _cTokenAddresses, bool _tradeForMorphoToken)
        external
        returns (uint256 claimedAmount);
}
