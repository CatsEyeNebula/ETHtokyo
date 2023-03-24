// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;
import "./ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./PassCard.sol";
import "../Interfaces/IController.sol";
import "../Interfaces/IResovler.sol";
import "./PassCard.sol";
import "../Interfaces/IEns.sol";



contract DaoDomain{
    IController public controller = IController(0x57f1887a8BF19b14fC0dF6Fd9B2acc9Af147eA85);
    address controllerAdr = 0x57f1887a8BF19b14fC0dF6Fd9B2acc9Af147eA85;
    constructor() {
        ens = IEns(0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e); // this is test network
    }

    event sendtoEns(
        bytes32 node,
        bytes32 label,
        address registant,
        address resolver
    );

    PassCard public passcard;
    mapping(uint256 => bytes32) public PasscardToDomain;
    mapping(uint256 => bool) public PasscardToBind;
    bytes32 private constant ETH_NODE =
        0x93cdeb708b7545dc668eb9280176169d1c33cfd8ed6f04690a0bcc88a93fc4ae;
    address registant;
    bytes32 Adrnode;
    bytes32 node;
    bytes a;
    IEns public ens;
    IResolver public resolver;
    mapping (address => string) adrToName;
 

    function setPassCard(address _adr) external {
        passcard = PassCard(_adr);
    }

    //TODO 
    modifier validate(uint256 tokenId) {
        address caller = passcard.ownerOf(tokenId);
        require(msg.sender == caller,"not token owner");
        _;
    }

    function claim(bytes32 _label,uint256 tokenId,string memory _nodename) external validate(tokenId) {
        _claim(tokenId,_label,_nodename);
    }


    function issueDomain(string memory nodename) external{
       bytes32 hashname = keccak256(abi.encodePacked(nodename));
       uint256 id = uint256(hashname);
    //    controller.reclaim(id, address(this));
       controllerAdr.delegatecall(abi.encodeWithSignature("reclaim(uint256,address)", id,address(this)));
    }

    function _claim(uint256 tokenId,bytes32 _label,string memory _nodename) public {
        computeForDao(_label,_nodename);
        address _resolver = ens.resolver(node);
        ens.setSubnodeRecord(node, _label, address(this),_resolver, 0);
        ens.setResolver(node,_resolver);
        resolver.setAddr(Adrnode, 60, a);
        ens.setSubnodeOwner(node, _label, registant);
        emit sendtoEns(node, _label, registant, _resolver);
        cleardata();
        PasscardToDomain[tokenId] = _label;
        PasscardToBind[tokenId] = true;
        adrToName[address(this)] = _nodename;
    }

    function getAllPassCard() view external returns(uint256[] memory){
        return passcard.getallTokenId(msg.sender);
    }

    function getPassCardStatus(uint256 tokenId) view external returns(bool) {
        return PasscardToBind[tokenId];
    }

    function computeForDao(bytes32 _label,string memory _nodename) internal {
        registant = tx.origin;
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

    function transferPassCardAndSubDomain(address to,uint256 tokenId,string memory _nodename) external {
        passcard.transferFrom(msg.sender, to, tokenId);
        bytes32 _label = PasscardToDomain[tokenId];
        computeForDao(_label,_nodename);
        ens.setSubnodeRecord(node,_label,address(0x0),address(0x0),0);
        cleardata();
    }

    function setSubnodeRecord(bytes32 _label) public {
        ens.setSubnodeRecord(node, _label, address(this), ens.resolver(node), 0);
    }

    function setResolver(address _resolver) public {
        ens.setResolver(node, _resolver);
    }

    function setAddr(address to) public {
        bytes memory _a = abi.encodePacked(to);
        resolver.setAddr(Adrnode, 60, _a);
    }

    function setSubnodeOwner(bytes32 _node,bytes32 _label,address to) internal {
        ens.setSubnodeOwner(_node, _label, to);
    }
  
}
