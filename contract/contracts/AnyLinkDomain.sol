// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;

import "../Interfaces/IEns.sol";
import "../Interfaces/INft.sol";
import "../Interfaces/IResovler.sol";
import "./SetSubDomain.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../Interfaces/IController.sol";


contract AnyLinkDomain is SetSubDomain {
    IController public controller = IController(0x57f1887a8BF19b14fC0dF6Fd9B2acc9Af147eA85);

    constructor() SetSubDomain() {}

    // modifier validate(uint256 tokenId, address tokenAddress) {
    //     address caller = nft.ownerOf(tokenId);
    //     require(tx.origin == caller, "not token owner");
    //     registant = tx.origin;
    //     _;
    // }

    function claim(
        bytes32 _label,
        string memory _nodename
    ) external {
        startAnyLink(_label,_nodename);
    }

    function issueDomain(string memory nodename) external{
       bytes32 hashname = keccak256(abi.encodePacked(nodename));
       uint256 id = uint256(hashname);
       controller.reclaim(id, address(this));
    }
}
