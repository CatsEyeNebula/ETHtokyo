// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;

interface INFT {
    function ownerOf(uint256 tokenId) external view returns (address owner);
    function owner() external view returns(address);
}
