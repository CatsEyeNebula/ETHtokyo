// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;
import "./ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./PassCard.sol";
import "../Interfaces/IController.sol";


contract DaoDomain {
    PassCard public passcard;
    IController public controller = IController(0x57f1887a8BF19b14fC0dF6Fd9B2acc9Af147eA85);

    constructor() {}

    modifier validate(uint256 tokenId) {
        address caller = passcard.ownerOf(tokenId);
        require(msg.sender == caller,"not token owner");
    }

    function claim(bytes32 _label,uint256 tokenId,string _nodename,uint256 tokenId) external validate(tokenId){
        startDAO(_label,_nodename,tokenId);
    }

    function issueDomain(string memory nodename) external{
       bytes32 hashname = keccak256(abi.encodePacked(nodename));
       uint256 id = uint256(hashname);
       controller.reclaim(id, address(this));
    }

  
}
