// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;
import "./ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract DaoPassDomain {
  
    IAzuki public azuki;
    IResolver public resolver;

    constructor() {
    }

    function validate(uint256 tokenId) internal returns(bool) {
        address caller = dao.getOwnershipData(tokenId).addr;
        require(tx.origin == caller,"not token owner");
        registant = tx.origin;
    }

}
