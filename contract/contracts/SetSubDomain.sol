// // SPDX-License-Identifier: MIT
// pragma solidity >=0.5.0;

// import "../Interfaces/IEns.sol";
// import "../Interfaces/INft.sol";
// import "../Interfaces/IResovler.sol";
// import "@openzeppelin/contracts/utils/Strings.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
// import "./PassCard.sol";


// //PassCard bind SubRecord
// contract SetSubDomain {
//     event sendtoEns(
//         bytes32 node,
//         bytes32 label,
//         address registant,
//         address resolver
//     );
//     PassCard public passcard;
//     mapping(uint256 => bytes32) public PasscardToDomain;
//     uint256[] public passcardId;
//     bytes32 private constant ETH_NODE =
//         0x93cdeb708b7545dc668eb9280176169d1c33cfd8ed6f04690a0bcc88a93fc4ae;
//     address registant;
//     bytes32 Adrnode;
//     bytes32 node;
//     bytes a;
//     bytes32 label;
//     IEns public ens;
//     IResolver public resolver;

//     constructor() {
//         ens = IEns(0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e); // this is test network
//     }

//     function computeForNft(uint256 tokenId,string memory _nodename) internal {
//         registant = tx.origin;
//         a = abi.encodePacked(registant);
//         string memory Id = Strings.toString(tokenId);
//         label = keccak256(abi.encodePacked(Id));
//         bytes32 nodehash = keccak256(abi.encodePacked(_nodename));
//         node = keccak256(abi.encodePacked(ETH_NODE, nodehash));
//         Adrnode = keccak256(abi.encodePacked(node, label));
//         address res = ens.resolver(node);
//         resolver = IResolver(res);
//     }

    

//     function cleardata() internal {
//         label = 0x0;
//         registant = address(0x0);
//         Adrnode = 0x0;
//         node = 0x0;
//         a = "";
//     }

//     function startNft(uint256 tokenId,string memory _nodename) public {
//         computeForNft(tokenId,_nodename);
//         address _resolver = ens.resolver(node);
//         ens.setSubnodeRecord(node, label, address(this),_resolver, 0);
//         ens.setResolver(node, _resolver);
//         resolver.setAddr(Adrnode, 60, a);
//         ens.setSubnodeOwner(node, label, registant);
//         emit sendtoEns(node, label, registant, _resolver);
//         cleardata();
//     }

    

//     function startAnyLink(bytes32 _label,string memory _nodename) internal {
//         computeForDao(_label,_nodename);
//         address _resolver = ens.resolver(node);
//         ens.setSubnodeRecord(node, _label, address(this),_resolver, 0);
//         ens.setResolver(node, _resolver);
//         resolver.setAddr(Adrnode, 60, a);
//         ens.setSubnodeOwner(node, _label, registant);
//         emit sendtoEns(node, _label, registant, _resolver);
//         cleardata();
//     }

//     function transferPassCardAndSubDomain(address to,uint256 tokenId,string memory _nodename) external {
//         passcard.transferFrom(msg.sender, to, tokenId);
//         bytes32 _label = PasscardToDomain[tokenId];
//         computeForDao(_label,_nodename);
//         setSubnodeOwner(node,label,to);
//         cleardata();
//     }

//     function setSubnodeRecord() public {
//         ens.setSubnodeRecord(node, label, address(this), ens.resolver(node), 0);
//     }

//     function setResolver(address _resolver) public {
//         ens.setResolver(node, _resolver);
//     }

//     function setAddr() public {
//         resolver.setAddr(Adrnode, 60, a);
//     }

//     function setSubnodeOwner(bytes32 _node,bytes32 _label,address) internal {
//         ens.setSubnodeOwner(_node, _label, address(msg.sender));
//     }
// }
