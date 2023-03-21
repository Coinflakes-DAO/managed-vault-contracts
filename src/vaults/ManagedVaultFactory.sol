// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./ManagedVault.sol";

contract ManagedVaultFactory is Ownable {
    using Clones for address;

    address public implementation;

    event UpdateImplementation(address indexed newImplementation, address indexed oldImplementation);

    event CreateManagedVault(address indexed contractAddress, string indexed tokenName, string indexed tokenSymbol);

    constructor(address impl_) Ownable() {
        _updateImpl(impl_);
    }

    function create(
        address manager_,
        address asset_,
        string memory name_,
        string memory symbol_
    ) external returns (address contractAddress) {
        contractAddress = implementation.clone();
        ManagedVault(contractAddress).initialize(manager_, asset_, name_, symbol_);
        emit CreateManagedVault(contractAddress, name_, symbol_);
    }

    function updateImplementation(address impl_) external onlyOwner {
        address prevImpl_ = implementation;
        _updateImpl(impl_);
        emit UpdateImplementation(impl_, prevImpl_);
    }

    function _updateImpl(address impl_) private {
        implementation = impl_;
    }
}
