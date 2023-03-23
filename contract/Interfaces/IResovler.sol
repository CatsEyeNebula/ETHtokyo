// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;

interface IResolver {
    function setAddr(bytes32 node, uint256 coinType, bytes memory a) external;
}
