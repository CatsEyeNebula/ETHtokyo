// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;

import "../Interfaces/IEns.sol";
import "../Interfaces/INft.sol";
import "../Interfaces/IResovler.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./PassCard.sol";


//PassCard bind SubRecord
contract SetSubDomain {
    event sendtoEns(
        bytes32 node,
        bytes32 label,
        address registant,
        address resolver
    );
    PassCard public passcard;
    mapping(uint256 => bytes32) public PasscardToDomain;
    uint256[] public passcardId;
    bytes32 private constant ETH_NODE =
        0x93cdeb708b7545dc668eb9280176169d1c33cfd8ed6f04690a0bcc88a93fc4ae;
    bytes32 label;
    address registant;
    bytes32 Adrnode;
    bytes32 node;
    bytes a;
    string nodename;
    IEns public ens;
    IResolver public resolver;

    constructor() {
        ens = IEns(0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e); // this is test network
    }

    function validate() virtual {}

    function computeForNft(uint256 tokenId,string memory _nodename) internal {
        registant = tx.origin;
        nodename = _nodename;
        string memory Id = Strings.toString(tokenId);
        bytes32 _label = keccak256(abi.encodePacked(tokenId));
        bytes32 nodehash = keccak256(abi.encodePacked(nodename));
        node = keccak256(abi.encodePacked(ETH_NODE, nodehash));
        Adrnode = keccak256(abi.encodePacked(node, _label));
        address res = ens.resolver(node);
        resolver = IResolver(res);
    }

    function computeForDao(bytes32 _label,string memory nodename) internal {
        registant = tx.origin;
        nodename = _nodename;
        bytes32 nodehash = keccak256(abi.encodePacked(nodename));
        node = keccak256(abi.encodePacked(ETH_NODE, nodehash));
        Adrnode = keccak256(abi.encodePacked(node, _label));
        address res = ens.resolver(node);
        resolver = IResolver(res);
    }

    function cleardata() internal {
        label = 0x0;
        registant = address(0x0);
        Adrnode = 0x0;
        node = 0x0;
        a = 0x0;
        nodename = "";
    }

    function startNft(uint256 tokenId,string memory _nodename) internal {
        computeForNft(tokenId,_nodename);
        ens.setSubnodeRecord(node, label, address(msg.sender), ens.resolver(node), 0);
        ens.setResolver(node, ens.resolver(node));
        resolver.setAddr(Adrnode, 60, a);
        ens.setSubnodeOwner(node, label, registant);
        emit sendtoEns(node, label, registant, ens.resolver(node));
        cleardata();
    }

    function startDAO(uint256 tokenId,bytes32 _label,string memory _nodename) internal {
        computeForDao(_label,_nodename);
        ens.setSubnodeRecord(node, label, address(msg.sender), ens.resolver(node), 0);
        ens.setResolver(node, ens.resolver(node));
        resolver.setAddr(Adrnode, 60, a);
        ens.setSubnodeOwner(node, label, registant);
        emit sendtoEns(node, label, registant, ens.resolver(node));
        cleardata();
        passcardId.push(tokenId);
        PasscardToDomain[tokenId] = _label;
    }

    function transferPassCardAndSubDomain(address to,uint256 tokenId,string memory _nodename) external {
        passcard.transferFrom(msg.sender, to, tokenId);
        bytes32 _label = PasscardToDomain[tokenId];
        computeForDao(_label,_nodename);
        setSubnodeOwner(node,label,to);
        cleardata();
    }

    function setSubnodeRecord() public {
        ens.setSubnodeRecord(node, label, address(this), ens.resolver(node), 0);
    }

    function setResolver(address _resolver) public {
        ens.setResolver(node, _resolver);
    }

    function setAddr() public {
        resolver.setAddr(Adrnode, 60, a);
    }

    function setSubnodeOwner() internal {
        ens.setSubnodeOwner(node, label, address(msg.sender));
    }
}
