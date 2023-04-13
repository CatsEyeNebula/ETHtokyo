// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;

import "../Interfaces/IENS.sol";
import "../Interfaces/INFT.sol";
import "../Interfaces/IResovler.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./PassCard.sol";
import "./VerifiedENS.sol";
import "../Interfaces/IStorageDomain.sol";

contract NFTDomain is Ownable, VerifiedENS {
    IStorageDomain public storagedomain;
    INFT public nft;
    event claimed(uint256 tokenId,address tokenAddress,address user);

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

    struct UserDomainState {
        bool claimed;
        string domain;
        uint256 tokenId;
    }

    mapping(address => mapping(uint256 => bytes32)) public NFTtoDomain;
    mapping(address => mapping(uint256 => bool)) public NFTtoBind;
    bytes32 private constant ETH_NODE =
        0x93cdeb708b7545dc668eb9280176169d1c33cfd8ed6f04690a0bcc88a93fc4ae;
    address registant;
    bytes32 Adrnode;
    bytes32 node;
    bytes a;
    bytes32 label;
    IResolver public resolver;
    address[] public NftAddr;

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
            checkAddress(tokenAddress),"haven't issued yet!"
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
            if (storagedomain.getENS_RECORD_ARR_ContractAddress(i) == tokenAddress) {
                require(
                    NFTtoBind[tokenAddress][tokenId] == false,
                    "already binded"
                );
                _nodename = storagedomain.getENS_RECORD_ARR_Domain(i);
                _claim(tokenId,tokenAddress, _nodename);
                string memory Id = Strings.toString(tokenId);
                label = keccak256(abi.encodePacked(Id));
                storagedomain.setUserSubDomain(msg.sender, tokenAddress, label, tokenId);
                label = 0x0;
                emit claimed(tokenId,tokenAddress,msg.sender);
            } 
        }
    }

    // 注意total supply
    function issueDomain(
        string memory nodename,
        address tokenAddress,
        uint256 _tokenId
    ) external {
        nft = INFT(tokenAddress);
        address CollectionOwner = nft.owner();
        require(CollectionOwner == msg.sender, "not collection owner");
        // if (
            // storagedomain.getProJectTeam(msg.sender, nodename) == address(0)) 
            // {
            NftAddr.push(tokenAddress);
            storagedomain.putENS_RECORD(1, tokenAddress, nodename);
            storagedomain.setProJectTeam(msg.sender, nodename, tokenAddress);
        // } else {
        //     require(false, "already issued!");
        // }
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

    function getStorageDomainAddr() view external returns(address){
        return storagedomain.getStorageDomainAddr();
    }

    function checkAddress(address tokenAddress) view internal returns(bool){
        bool flag = false;
        uint256 len = NftAddr.length;
        for(uint256 i = 0;i < len; i++){
            if(NftAddr[i] == tokenAddress){
                flag = true;
            }
        }
        return flag;
    }
    
    function getNftAddrArr() view external returns(address[] memory){
        return NftAddr;
    }

    function getNftList(address tokenAddress) view external returns(UserDomainState[] memory){
        uint256 len = INFT(tokenAddress).totalSupply();
        UserDomainState[] memory arr = new UserDomainState[](len);
        for(uint256 i = 0;i < len; i++){
            if(msg.sender == INFT(tokenAddress).ownerOf(i)){
               UserDomainState memory userdomainstate;
               userdomainstate.claimed = NFTtoBind[tokenAddress][i];
               userdomainstate.tokenId = i;
               userdomainstate.domain = storagedomain.getDomainByAddress(tokenAddress);
               arr[i] = userdomainstate;
            }
        }
        return arr;
    }
    

    // function setSubnodeRecord() public {
    //     ens.setSubnodeRecord(node, label, address(this), ens.resolver(node), 0);
    // }

    // function setResolver(address _resolver) public {
    //     ens.setResolver(node, _resolver);
    // }

    // function setAddr() public {
    //     resolver.setAddr(Adrnode, 60, a);
    // }

    // function setSubnodeOwner(bytes32 _node, bytes32 _label, address) internal {
    //     ens.setSubnodeOwner(_node, _label, address(msg.sender));
    // }
}
