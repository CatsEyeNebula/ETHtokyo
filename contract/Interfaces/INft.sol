// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;

interface INft {
    function ownerOf(uint256 tokenId) external view returns (address owner);
}
