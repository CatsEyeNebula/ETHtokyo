// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;
import "./ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./PassCard.sol";
import "../Interfaces/IResovler.sol";
import "../Interfaces/IENS.sol";
import "./VerifiedENS.sol";
import "./PassCardFactory.sol";
import "../Interfaces/IStorageDomain.sol";

contract DaoDomain is VerifiedENS,PassCardFactory{
    event claimed(uint256 tokenId,address passcardAdr,address user);
    address factoryAdr;
    address storagemainAddr;
    constructor(address _storagemainAddr)PassCardFactory(_storagemainAddr) {
        ens = IENS(0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e); // this is test network
        storagemainAddr = _storagemainAddr;
    }

    event sendtoEns(
        bytes32 node,
        bytes32 label,
        address registant,
        address resolver
    );

    PassCard public passcard;
    mapping(address => mapping(uint256 => bytes32)) public PasscardToDomain;
    mapping(address => mapping(uint256 => bool)) public PasscardToBind;
    bytes32 private constant ETH_NODE =
        0x93cdeb708b7545dc668eb9280176169d1c33cfd8ed6f04690a0bcc88a93fc4ae;
    address registant;
    bytes32 Adrnode;
    bytes32 node;
    bytes a;
    IResolver public resolver;
    address[] public PassCardAddr;


    function issueDomain(
        string memory name,
        string memory symbol,
        uint256 _tokenId,
        bool transferable,
        bool revokable,
        address[] calldata _address
    ) external {
        if (IStorageDomain(storagemainAddr).getProJectTeam(msg.sender,name) == address(0)) {
            address _passcardAdr = _deployPassCard(name, symbol,revokable,transferable);
            PassCardAddr.push(_passcardAdr);
            passcard = PassCard(_passcardAdr);
            passcard.setAirDropAddr(_address);
            passcard.multiTransferToken();
        }
        else {
            address _passcardAdr = IStorageDomain(storagemainAddr).getProJectTeam(msg.sender,name);
            passcard = PassCard(_passcardAdr);
            passcard.setAirDropAddr(_address);
            passcard.multiTransferToken();
        }
    }

    modifier validate(uint256 tokenId, address _passcardAdr) {
        passcard = PassCard(_passcardAdr);
        address caller = passcard.ownerOf(tokenId);
        require(msg.sender == caller, "not token owner");
        _;
    }

    function claim(
        bytes32 _label,
        uint256 tokenId,
        address _passcardAdr
    ) external validate(tokenId, _passcardAdr) {
        uint256 len = storagedomain.getENSRecordArrLength();
        for (uint256 i = 0; i < len; i++) {
            if (IStorageDomain(storagemainAddr).getENS_RECORD_ARR_ContractAddress(i) == _passcardAdr) {
                require(
                    PasscardToBind[_passcardAdr][tokenId] == false,
                    "already claimed"
                );
                string memory _nodename = IStorageDomain(storagemainAddr).getENS_RECORD_ARR_Domain(i);
                _claim(tokenId, _label, _nodename);
                IStorageDomain(storagemainAddr).setUserSubDomain(
                    msg.sender,
                    _passcardAdr,
                    _label,
                    tokenId
                );
                emit claimed(tokenId,_passcardAdr,msg.sender);
            } 
        }
    }

    function _claim(
        uint256 tokenId,
        bytes32 _label,
        string memory _nodename
    ) internal {
        generateDAODomain(_label, _nodename);
        address _resolver = ens.resolver(node);
        ens.setSubnodeRecord(node, _label, address(this), _resolver, 0);
        ens.setResolver(node, _resolver);
        resolver.setAddr(Adrnode, 60, a);
        ens.setSubnodeOwner(node, _label, registant);
        emit sendtoEns(node, _label, registant, _resolver);
        cleardata();
        PasscardToDomain[address(passcard)][tokenId] = _label;
        PasscardToBind[address(passcard)][tokenId] = true;
    }

    function getAllPassCard() external view returns (uint256[] memory) {
        return passcard.getallTokenId(msg.sender);
    }

    function getPassCardStatus(uint256 tokenId) external view returns (bool) {
        return PasscardToBind[msg.sender][tokenId];
    }

    function generateDAODomain(
        bytes32 _label,
        string memory _nodename
    ) internal {
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

    function transferPassCardAndSubDomain(
        address to,
        uint256 tokenId,
        string memory _nodename,
        address _passcardAdr
    ) external validate(tokenId, _passcardAdr) {
        passcard.transferFrom(msg.sender, to, tokenId);
        bytes32 _label = PasscardToDomain[address(passcard)][tokenId];
        generateDAODomain(_label, _nodename);
        ens.setSubnodeRecord(node, _label, address(0x0), address(0x0), 0);
        PasscardToDomain[address(passcard)][tokenId] = 0x0;
        cleardata();
    }

    function revoke(uint256 tokenId,string memory _nodename,address _passcardAdr) external validate(tokenId,_passcardAdr) {
        passcard.burn(tokenId);
        bytes32 _label = PasscardToDomain[address(passcard)][tokenId];
        generateDAODomain(_label, _nodename);
        ens.setSubnodeRecord(node, _label, address(0x0), address(0x0), 0);
        cleardata();
        PasscardToDomain[address(passcard)][tokenId] = 0x0;
        PasscardToBind[address(passcard)][tokenId] = false;
    }

    // function setSubnodeRecord(bytes32 _label) public {
    //     ens.setSubnodeRecord(
    //         node,
    //         _label,
    //         address(this),
    //         ens.resolver(node),
    //         0
    //     );
    // }

    // function setResolver(address _resolver) public {
    //     ens.setResolver(node, _resolver);
    // }

    // function setAddr(address to) public {
    //     bytes memory _a = abi.encodePacked(to);
    //     resolver.setAddr(Adrnode, 60, _a);
    // }

    // function setSubnodeOwner(
    //     bytes32 _node,
    //     bytes32 _label,
    //     address to
    // ) internal {
    //     ens.setSubnodeOwner(_node, _label, to);
    // }

    function getPassCardFactoryAddr() view external returns(address){
        return PassCardFactory._getPassCardFactoryAddr();
    }

    function getStorageDomainAddress() view external returns(address){
        return IStorageDomain(storagemainAddr).getStorageDomainAddr();
    }
    
}
