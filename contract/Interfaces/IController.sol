// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;


interface IController{
    function reclaim(uint256 id, address owner) external;
}
