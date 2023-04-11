// SPDX-License-Identifier: MIT
pragma solidity >=0.4.16 <0.9.0;

import "../Interfaces/IENS.sol";

contract VerifiedENS{
    IENS public ens;
    constructor() {
        ens = IENS(0x57f1887a8BF19b14fC0dF6Fd9B2acc9Af147eA85);
    }

    modifier verify(uint256 _tokenId){
        address caller = ens.ownerOf(_tokenId);
        require(msg.sender == caller,"caller doesn't own this ENSdomain");
        _;
    }
}