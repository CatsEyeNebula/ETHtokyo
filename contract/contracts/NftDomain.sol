// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;

import "../Interfaces/IEns.sol";
import "../Interfaces/INft.sol";
import "../Interfaces/IResovler.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../Interfaces/IController.sol";
import "./PassCard.sol";



contract NftDomain  {
    INft public nft;
    IController public controller = IController(0x57f1887a8BF19b14fC0dF6Fd9B2acc9Af147eA85);
    address controllerAdr = 0x57f1887a8BF19b14fC0dF6Fd9B2acc9Af147eA85;

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
    address registant;
    bytes32 Adrnode;
    bytes32 node;
    bytes a;
    bytes32 label;
    IEns public ens;
    IResolver public resolver;
    mapping (address => string) adrToName;
    address[] public NftAddr;

    constructor() {
        ens = IEns(0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e); // this is test network
    }

    function setNftAddress(address nftadr) external {
        nft = INft(nftadr);
    }

    function getAddr(uint256 tokenId) view external returns(address){
        return nft.ownerOf(tokenId);
    }

    //TODO 
    modifier validate(uint256 tokenId, address tokenAddress,string memory _nodename) {
        require(keccak256(abi.encodePacked(adrToName[tokenAddress])) == keccak256(abi.encodePacked(_nodename)));
        address caller = nft.ownerOf(tokenId);
        require(msg.sender == caller, "not token owner");
        _;
    }

    function claim(
        uint256 tokenId,
        address tokenAddress,
        string memory _nodename
    ) external validate(tokenId, tokenAddress,_nodename) {
       startNft(tokenId,_nodename);
       adrToName[tokenAddress] = _nodename;
    }

    function issueDomain(string memory nodename,address tokenAddress) external{
       bytes32 hashname = keccak256(abi.encodePacked(nodename));
       uint256 id = uint256(hashname);
    //    controller.reclaim(id, address(this));
       controllerAdr.delegatecall(abi.encodeWithSignature("reclaim(uint256,address)", id,address(this)));
    }

    function pushNftAddr(address tokenAddress) external{
       NftAddr.push(tokenAddress);
    }

    function computeForNft(uint256 tokenId,string memory _nodename) internal {
        registant = tx.origin;
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

    function startNft(uint256 tokenId,string memory _nodename) public {
        computeForNft(tokenId,_nodename);
        address _resolver = ens.resolver(node);
        ens.setSubnodeRecord(node, label, address(this),_resolver, 0);
        ens.setResolver(node, _resolver);
        resolver.setAddr(Adrnode, 60, a);
        ens.setSubnodeOwner(node, label, registant);
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

    function setSubnodeOwner(bytes32 _node,bytes32 _label,address) internal {
        ens.setSubnodeOwner(_node, _label, address(msg.sender));
    }
    

}
