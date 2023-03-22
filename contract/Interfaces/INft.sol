// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;

interface INft {

    struct TokenOwnership {
    address addr;
    uint64 startTimestamp;
  }

   function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory);
}
