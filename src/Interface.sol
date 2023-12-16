// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IPool {
    function ADDRESSES_PROVIDER() external view returns (address);

    //   function getConfiguration(
    //     address asset
    //   ) external view returns (DataTypes.ReserveConfigurationMap memory);

    //   function pepito() external view returns(bool);

    //   function deposit(address asset, uint256 amount, address onBehalfOf, uint16 referralCode) external;
}
