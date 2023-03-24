// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;

import "../Interfaces/IEns.sol";
import "../Interfaces/INft.sol";
import "../Interfaces/IResovler.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../Interfaces/IController.sol";
import "./PassCard.sol";



contract AnyLinkDomain {
    IController public controller = IController(0x57f1887a8BF19b14fC0dF6Fd9B2acc9Af147eA85);

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
    IEns public ens;
    IResolver public resolver;

    constructor() {
        ens = IEns(0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e); // this is test network
    }

    // modifier validate(uint256 tokenId, address tokenAddress) {
    //     address caller = nft.ownerOf(tokenId);
    //     require(tx.origin == caller, "not token owner");
    //     registant = tx.origin;
    //     _;
    // }

    function claim(
        bytes32 _label,
        string memory _nodename
    ) external {
        startAnyLink(_label,_nodename);
    }

    function issueDomain(string memory nodename) external{
       bytes32 hashname = keccak256(abi.encodePacked(nodename));
       uint256 id = uint256(hashname);
       controller.reclaim(id, address(this));
    }

    function startAnyLink(bytes32 _label,string memory _nodename) internal {
        computeForDao(_label,_nodename);
        address _resolver = ens.resolver(node);
        ens.setSubnodeRecord(node, _label, address(this),_resolver, 0);
        ens.setResolver(node, _resolver);
        resolver.setAddr(Adrnode, 60, a);
        ens.setSubnodeOwner(node, _label, registant);
        emit sendtoEns(node, _label, registant, _resolver);
        cleardata();
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

    function setSubnodeRecord(bytes32 _label) public {
        ens.setSubnodeRecord(node, _label, address(this), ens.resolver(node), 0);
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
