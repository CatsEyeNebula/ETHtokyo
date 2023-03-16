
// SPDX-License-Identifier: MIT
pragma solidity >=0.4.16 <0.9.0;



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


contract EnsDemo {
    bytes32 public label =0x23dc111d7c3ad1df9806ce1e8eb4f55f57dba117339c545e7593d1f6c3b02662;
    address ens = 0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e;
    address resolver = 0xd7a4F6473f32aC2Af804B3686AE8F1932bC35750;
    bytes32 nodehash = keccak256(abi.encodePacked("opns"));
    address registant = 0x1B888605F9d83641F6d526ed6c92F6e9ca582De0;
    bytes public a = abi.encodePacked(registant);
    bytes32 public ETH_NODE = 0x93cdeb708b7545dc668eb9280176169d1c33cfd8ed6f04690a0bcc88a93fc4ae;
    bytes32 public node = keccak256(abi.encodePacked(ETH_NODE,nodehash));
    bytes32 public Adrnode = keccak256(abi.encodePacked(node,label));

    function start() external{
        ENS(ens).setSubnodeRecord(node, label, address(this), resolver, 0);
        Adrnode = keccak256(abi.encodePacked(node,label));
        ENS(ens).setResolver(node, resolver);
        ENS(resolver).setAddr(Adrnode, 60, a);
        ENS(ens).setSubnodeOwner(node,label,registant);
    }

    function setSubnodeRecord() external{
        ENS(ens).setSubnodeRecord(node, label, address(this), resolver, 0);
    }

    function setAddr() external{
        ENS(resolver).setAddr(Adrnode, 60, a);
    }
    
    function setResolver() external{
        ENS(ens).setResolver(node, resolver);
    }
   
    function setSubnodeOwner() external{
        ENS(ens).setSubnodeOwner(node,label,registant);
    }

    function setSubnodeThis() external{
        ENS(ens).setSubnodeOwner(node,label,address(this));
    }

    function setAdrnode(bytes32 _Adrnode) external{
        Adrnode = _Adrnode;
    }
}









