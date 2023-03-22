// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;

import "../Interfaces/ENS.sol";
import "../Interfaces/INft.sol";
import "../Interfaces/IResovler.sol";
import "contract/contracts/SetSubDomain.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract NftDomain is SetSunDomain {    

    INft public nft;

    constructor() SetSubDomain(){
    }

    function setNftAddress(address nftadr) external {
        nft = INft(nftadr);
    }


    // function validate(uint256 tokenId) internal returns(bool) {
    //     address caller = nft.getOwnershipData(tokenId).addr;
    //     require(tx.origin == caller,"not token owner");
    //     registant = tx.origin;
    // }
}