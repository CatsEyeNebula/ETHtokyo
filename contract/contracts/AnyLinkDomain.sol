// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;

import "../Interfaces/IENS.sol";
import "../Interfaces/IResovler.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../Interfaces/IController.sol";
import "./PassCard.sol";
import "./VerifiedENS.sol";
import "./StorageDomain.sol";

contract AnyLinkDomain is Ownable,VerifiedENS, StorageDomain{
    IController public controller = IController(0x57f1887a8BF19b14fC0dF6Fd9B2acc9Af147eA85);
    StorageDomain public storagedomain;

    event sendtoEns(
        bytes32 node,
        bytes32 label,
        address registant,
        address resolver
    );
    uint256[] public passcardId;
    bytes32 private constant ETH_NODE =
        0x93cdeb708b7545dc668eb9280176169d1c33cfd8ed6f04690a0bcc88a93fc4ae;
    address registant;
    bytes32 Adrnode;
    bytes32 node;
    bytes a;
    IResolver public resolver;

    constructor() {
        ens = IENS(0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e); // this is test network
    }

    // modifier validate(uint256 tokenId, address tokenAddress) {
    //     address caller = nft.ownerOf(tokenId);
    //     require(tx.origin == caller, "not token owner");
    //     registant = tx.origin;
    //     _;
    // }

    function setStorafeDomainAdr(address StorageDomainAdr) public onlyOwner {
        storagedomain = StorageDomain(StorageDomainAdr);
    }

    function claim(
        bytes32 _label,
        string memory _nodename
    ) external {
        _claim(_label,_nodename);
    }

    // function issueDomain(
    //     string memory nodename,
    //     address tokenAddress,
    //     bytes32 _node
    // ) external verify(_node) {
    //     require(CollectionOwner == msg.sender, "not collection owner");
    //     if (storagedomain.ProJectTeam(msg.sender, nodename) == address(0)) {
    //         ENS_RECORD memory ens_record;
    //         ens_record.index = 2;
    //         ens_record.contractAddress = tokenAddress;
    //         ens_record.domain = nodename;
    //         storagedomain._putENS_RECORD(ens_record);
    //         storagedomain._setProJectTeam(
    //             msg.sender,
    //             nodename,
    //             ens_record.contractAddress
    //         );
    //     } else {
    //         require(false, "already issued!");
    //     }
    // }

    function _claim(bytes32 _label,string memory _nodename) internal {
        generateAnyLinkDomain(_label,_nodename);
        address _resolver = ens.resolver(node);
        ens.setSubnodeRecord(node, _label, address(this),_resolver, 0);
        ens.setResolver(node, _resolver);
        resolver.setAddr(Adrnode, 60, a);
        ens.setSubnodeOwner(node, _label, registant);
        emit sendtoEns(node, _label, registant, _resolver);
        cleardata();
    }

    function generateAnyLinkDomain(bytes32 _label,string memory _nodename) internal {
        registant = msg.sender;
        a = abi.encodePacked(registant);
        bytes32 nodehash = keccak256(abi.encodePacked(_nodename));
        node = keccak256(abi.encodePacked(ETH_NODE, nodehash));
        Adrnode = keccak256(abi.encodePacked(node, _label));
        address res = ens.resolver(node);
        resolver = IResolver(res);
    }

    function cleardata() internal {
        registant = address(0x0);
        Adrnode = 0x0;
        node = 0x0;
        a = "";
    }

    function setSubnodeRecord(bytes32 _label) public {
        ens.setSubnodeRecord(node, _label, address(this), ens.resolver(node), 0);
    }

    function setResolver(address _resolver) public {
        ens.setResolver(node, _resolver);
    }

    function setAddr() public {
        resolver.setAddr(Adrnode, 60, a);
    }

    function setSubnodeOwner(bytes32 _node,bytes32 _label,address) internal {
        ens.setSubnodeOwner(_node, _label, address(msg.sender));
    }

}
