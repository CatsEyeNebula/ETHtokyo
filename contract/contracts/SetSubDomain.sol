// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;

import "../Interfaces/ENS.sol";
import "../Interfaces/INft.sol";
import "../Interfaces/IResovler.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


    contract SetSubDomain {
    event sendtoEns(bytes32 node, bytes32 label, address registant,address resolver);
    
    bytes32 private constant ETH_NODE =
        0x93cdeb708b7545dc668eb9280176169d1c33cfd8ed6f04690a0bcc88a93fc4ae;
    bytes32 label;
    address registant;
    uint16 index;
    bytes32 Adrnode;
    bytes32 node;
    bytes a;
    string nodename;
    ENS public ens;
    IResolver public resolver;

    constructor() {
       ens = ENS(0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e);// this is test network
    }

    function validate() virtual{

    }

    function computeForNft(uint256 tokenId) internal {
        string memory Id = Strings.toString(tokenId);
        bytes32 _label = keccak256(abi.encodePacked(tokenId));
        bytes32 nodehash = keccak256(abi.encodePacked(nodename));
        node = keccak256(abi.encodePacked(ETH_NODE,nodehash));
        Adrnode  = keccak256(abi.encodePacked(node,_label));
        address res = ens.resolver(node);
        resolver = IResolver(res);
    }

    function computeForDao(bytes32 _label) internal {
        bytes32 nodehash = keccak256(abi.encodePacked(nodename));
        node = keccak256(abi.encodePacked(ETH_NODE,nodehash));
        Adrnode  = keccak256(abi.encodePacked(node,_label));
        address res = ens.resolver(node);
        resolver = IResolver(res);
    }

    function setNodeName(string memory _nodename) public {
        nodename = _nodename;
    }

    function start(uint256 tokenId,) external{
        compute(tokenId);
        ens.setSubnodeRecord(node, label, address(this), ens.resolver(node), 0);
        ens.setResolver(node, ens.resolver(node));
        resolver.setAddr(Adrnode, 60, a);
        ens.setSubnodeOwner(node,label,registant);
        emit sendtoEns(node, label, registant,ens.resolver(node));
        node = 0x0;
        label = 0x0;
        Adrnode = 0x0;
        registant = address(0x0);
    }

    function setSubnodeRecord() external {
         ens.setSubnodeRecord(node, label, address(this), ens.resolver(node), 0);
    }

    function setResolver(address _resolver) external {
        ens.setResolver(node, _resolver);
    }

    function setAddr() external {
        resolver.setAddr(Adrnode, 60, a);
    }

    function setSubnodeOwner() external {
        ens.setSubnodeOwner(node,label,registant);
    }
}