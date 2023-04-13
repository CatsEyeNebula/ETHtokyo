// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;

import "../Interfaces/IENS.sol";
import "../Interfaces/IResovler.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./VerifiedENS.sol";
import "../Interfaces/IStorageDomain.sol";
import "../Interfaces/INFT.sol";


contract AnyLinkDomain is Ownable,VerifiedENS{
    IStorageDomain public storagedomain;
    INFT public anylink;
    event claimed(uint256 tokenId,address anylinkAddress,address user);
    event sendtoEns(
        bytes32 node,
        bytes32 label,
        address registant,
        address resolver
    );

    constructor(address _storagemainAddr) {
        ens = IENS(0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e);
        storagedomain = IStorageDomain(_storagemainAddr);
    }

    mapping(address => mapping(uint256 => bytes32)) public AnyLinkToDomain;
    mapping(address => mapping(uint256 => bool)) public AnyLinkToBind;
    bytes32 private constant ETH_NODE =
        0x93cdeb708b7545dc668eb9280176169d1c33cfd8ed6f04690a0bcc88a93fc4ae;
    address registant;
    bytes32 Adrnode;
    bytes32 node;
    bytes a;
    IResolver public resolver;
    address[] public AnyLinkAddr;

    modifier validate(uint256 anylinktokenId, address tokenAddress) {
        address caller = anylink.ownerOf(anylinktokenId);
        require(msg.sender == caller, "not domain owner");
        _;
    }

    function claim(
        bytes32 _label,
        uint256 anylinktokenId,
        address _anylinkAdr
    ) external validate(anylinktokenId,_anylinkAdr){
        uint256 len = storagedomain.getENSRecordArrLength();
        for (uint256 i = 0; i < len; i++) {
            if (storagedomain.getENS_RECORD_ARR_ContractAddress(i) == _anylinkAdr) {
                require(
                    AnyLinkToBind[_anylinkAdr][anylinktokenId] == false,
                    "already binded"
                );
                string memory _nodename = storagedomain.getENS_RECORD_ARR_Domain(i);
                _claim(_label,_anylinkAdr, _nodename,anylinktokenId);
                storagedomain.setUserSubDomain(
                    msg.sender,
                    _anylinkAdr,
                    _label,
                    anylinktokenId
                );
                emit claimed(anylinktokenId,_anylinkAdr,msg.sender);
            } 
        }
    }

    function issueDomain(
        string memory nodename,
        address anylinkAddress,
        uint256 _tokenId
    ) external verify(_tokenId) {
        anylink = INFT(anylinkAddress);
        address CollectionOwner = anylink.owner();
        require(CollectionOwner == msg.sender, "not domain owner");
        if (storagedomain.getProJectTeam(msg.sender, nodename) == address(0)) {
            AnyLinkAddr.push(anylinkAddress);
            storagedomain.putENS_RECORD(2, anylinkAddress, nodename);
            storagedomain.setProJectTeam(
                msg.sender,
                nodename,
                anylinkAddress
            );
        } else {
            require(false, "already issued!");
        }
    }

    function _claim(bytes32 _label,address anylinkAdr,string memory _nodename,uint256 anylinktokenId) internal {
        generateAnyLinkDomain(_label,_nodename);
        address _resolver = ens.resolver(node);
        ens.setSubnodeRecord(node, _label, address(this),_resolver, 0);
        ens.setResolver(node, _resolver);
        resolver.setAddr(Adrnode, 60, a);
        ens.setSubnodeOwner(node, _label, registant);
        AnyLinkToBind[anylinkAdr][anylinktokenId] = true;
        AnyLinkToDomain[anylinkAdr][anylinktokenId] = _label;
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

    // function setSubnodeRecord(bytes32 _label) public {
    //     ens.setSubnodeRecord(node, _label, address(this), ens.resolver(node), 0);
    // }

    // function setResolver(address _resolver) public {
    //     ens.setResolver(node, _resolver);
    // }

    // function setAddr() public {
    //     resolver.setAddr(Adrnode, 60, a);
    // }

    // function setSubnodeOwner(bytes32 _node,bytes32 _label,address) internal {
    //     ens.setSubnodeOwner(_node, _label, address(msg.sender));
    // }

}
