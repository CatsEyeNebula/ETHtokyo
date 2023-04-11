// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;

import "../Interfaces/IENS.sol";
import "../Interfaces/INFT.sol";
import "../Interfaces/IResovler.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../Interfaces/IController.sol";
import "./PassCard.sol";
import "./VerifiedENS.sol";
import "./StorageDomain.sol";

contract NFTDomain is Ownable, VerifiedENS, StorageDomain {
    StorageDomain public storagedomain;
    INFT public nft;
    IController public controller =
        IController(0x57f1887a8BF19b14fC0dF6Fd9B2acc9Af147eA85);
    address controllerAdr = 0x57f1887a8BF19b14fC0dF6Fd9B2acc9Af147eA85;

    event sendtoEns(
        bytes32 node,
        bytes32 label,
        address registant,
        address resolver
    );
    PassCard public passcard;
    mapping(uint256 => bytes32) public PasscardToDomain;
    bytes32 private constant ETH_NODE =
        0x93cdeb708b7545dc668eb9280176169d1c33cfd8ed6f04690a0bcc88a93fc4ae;
    address registant;
    bytes32 Adrnode;
    bytes32 node;
    bytes a;
    bytes32 label;
    IResolver public resolver;
    address[] public NftAddr;

    mapping(address => mapping(uint256 => bytes32)) public NFTtoDomain;
    mapping(address => mapping(uint256 => bool)) public NFTtoBind;

    constructor() {
        ens = IENS(0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e); // this is test network
    }

    function setStorafeDomainAdr(address StorageDomainAdr) public onlyOwner {
        storagedomain = StorageDomain(StorageDomainAdr);
    }

    // function setNFTAddress(address nftadr) external onlyOwner{
    //     nft = INFT(nftadr);
    // }

    //TODO verify ownership control

    function getAddr(uint256 tokenId) external view returns (address) {
        return nft.ownerOf(tokenId);
    }

    //TODO
    modifier validate(
        uint256 tokenId,
        address tokenAddress,
        string memory _nodename
    ) {
        nft = INFT(tokenAddress);
        require(
            keccak256(
                abi.encodePacked(
                    storagedomain.ProJectTeam(msg.sender, _nodename)
                )
            ) == keccak256(abi.encodePacked(tokenAddress))
        );
        address caller = nft.ownerOf(tokenId);
        require(msg.sender == caller, "not token owner");
        _;
    }

    function claim(
        uint256 tokenId,
        address tokenAddress,
        string memory _nodename
    ) external validate(tokenId, tokenAddress, _nodename) {
        uint256 len = storagedomain.getENSRecordArrLength();
        for (uint256 i = 0; i < len; i++) {
            if (ENS_RECORD_ARR[i].contractAddress == tokenAddress) {
                require(
                    NFTtoBind[tokenAddress][tokenId] == false,
                    "already binded"
                );
                _nodename = ENS_RECORD_ARR[i].domain;
                _claim(tokenId,tokenAddress, _nodename);
                string memory Id = Strings.toString(tokenId);
                label = keccak256(abi.encodePacked(Id));
                storagedomain._setUserSubDomain(
                    msg.sender,
                    tokenAddress,
                    label,
                    tokenId
                );
                label = 0x0;
            } else {
                revert();
            }
        }
    }

    // 注意total supply
    // 检查是否是owener of the collection
    function issueDomain(
        string memory nodename,
        address tokenAddress,
        bytes32 _node
    ) external  {
        nft = INFT(tokenAddress);
        address CollectionOwner = nft.owner();
        require(CollectionOwner == msg.sender, "not collection owner");
        if (storagedomain.ProJectTeam(msg.sender, nodename) == address(0)) {
            ENS_RECORD memory ens_record;
            ens_record.index = 1;
            ens_record.contractAddress = tokenAddress;
            ens_record.domain = nodename;
            storagedomain._putENS_RECORD(ens_record);
            storagedomain._setProJectTeam(
                msg.sender,
                nodename,
                ens_record.contractAddress
            );
        } else {
            require(false, "already issued!");
        }
    }

    function pushNftAddr(address tokenAddress) external {
        NftAddr.push(tokenAddress);
    }

    function generateNFTDomain(
        uint256 tokenId,
        string memory _nodename
    ) internal {
        registant = msg.sender;
        a = abi.encodePacked(registant);
        string memory Id = Strings.toString(tokenId);
        label = keccak256(abi.encodePacked(Id));
        bytes32 nodehash = keccak256(abi.encodePacked(_nodename));
        node = keccak256(abi.encodePacked(ETH_NODE, nodehash));
        Adrnode = keccak256(abi.encodePacked(node, label));
        address res = ens.resolver(node);
        resolver = IResolver(res);
    }

    function cleardata() internal {
        label = 0x0;
        registant = address(0x0);
        Adrnode = 0x0;
        node = 0x0;
        a = "";
    }

    function _claim(uint256 tokenId, address tokenAddress,string memory _nodename) internal {
        generateNFTDomain(tokenId, _nodename);
        address _resolver = ens.resolver(node);
        ens.setSubnodeRecord(node, label, address(this), _resolver, 0);
        ens.setResolver(node, _resolver);
        resolver.setAddr(Adrnode, 60, a);
        ens.setSubnodeOwner(node, label, registant);
        NFTtoBind[tokenAddress][tokenId] = true;
        NFTtoDomain[tokenAddress][tokenId] = label;
        emit sendtoEns(node, label, registant, _resolver);
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

    function setSubnodeOwner(bytes32 _node, bytes32 _label, address) internal {
        ens.setSubnodeOwner(_node, _label, address(msg.sender));
    }
}
