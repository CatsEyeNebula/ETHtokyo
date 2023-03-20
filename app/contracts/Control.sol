// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;

interface ENS{
    function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external;
    function setResolver(bytes32 node, address resolver) external;
    function setOwner(bytes32 node, address owner) external;
    function setTTL(bytes32 node, uint64 ttl) external;
    function owner(bytes32 node) external view returns (address);
    function resolver(bytes32 node) external view returns (address);
    function setSubnodeRecord(bytes32 node, bytes32 label, address owner, address resolver, uint64 ttl) external;
    function reclaim(uint256 id, address owner) external;
    function setAddr(bytes32 node, uint256 coinType, bytes memory a) external;
}

contract Control  {

    event sendtoEns(bytes32 node, bytes32 label, address registant,address resolver);
    
    address ens =  0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e;
    address resolver = 0xd7a4F6473f32aC2Af804B3686AE8F1932bC35750;
    bytes32 private constant ETH_NODE =
        0x93cdeb708b7545dc668eb9280176169d1c33cfd8ed6f04690a0bcc88a93fc4ae;
    mapping (uint16 => mapping(bytes => mapping(uint16 => string))) check;
    string rec;
    bytes32 label;
    address registant;
    uint16 index;
    bytes32 Adrnode;
    bytes32 node;
    bytes a;
    string opns;
    bool flag;
    string suffix;



    function compute(bytes32 _label) internal{
        bytes32 nodehash = keccak256(abi.encodePacked(suffix));
        node = keccak256(abi.encodePacked(ETH_NODE,nodehash));
        Adrnode  = keccak256(abi.encodePacked(node,_label));
    }
   



    constructor() {

    }
    
    function validate(uint16 _chainId, bytes memory _srcAdr,uint16 _index) view public returns(string memory, bool){
        if(keccak256(abi.encodePacked(check[_chainId][_srcAdr][_index])) != keccak256(abi.encodePacked(''))){
            return (check[_chainId][_srcAdr][_index],true);
        }else{
            return ("not pass", false);
        }
    }

    function setSuffix(string memory _suffix) public {
        suffix = _suffix;
    }

    function start(bytes32 _label) external{
        compute(_label);
        ENS(ens).setSubnodeRecord(node, label, address(this), resolver, 0);
        ENS(ens).setResolver(node, resolver);
        ENS(resolver).setAddr(Adrnode, 60, a);
        ENS(ens).setSubnodeOwner(node,label,registant);
        emit sendtoEns(node, label, registant,resolver);
        node = 0x0;
        label = 0x0;
        Adrnode = 0x0;
        registant = address(0x0);
    }

    function setSubnodeRecord() external {
         ENS(ens).setSubnodeRecord(node, label, address(this), resolver, 0);
    }

    function setResolver() external {
        ENS(ens).setResolver(node, resolver);
    }

    function setAddr() external {
        ENS(resolver).setAddr(Adrnode, 60, a);
    }

    function setSubnodeOwner() external {
        ENS(ens).setSubnodeOwner(node,label,registant);
    }
}