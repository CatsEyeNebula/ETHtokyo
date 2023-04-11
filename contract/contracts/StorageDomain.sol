// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;
import "@openzeppelin/contracts/access/Ownable.sol";


contract StorageDomain is Ownable{
    
    constructor() Ownable(){
        
    }
    struct ENS_RECORD {
        uint256 index; //0 DAO_ENS  1 NFT_ENS  2 ANYLINK_ENS
        address contractAddress;
        string domain;
    }

    mapping (address => mapping(string => address)) public ProJectTeam;//useraddress => domain => contract address
    mapping (address => mapping(address => mapping(bytes32 => uint256))) public UserSubDomain; //useraddress => contract address => label  => tokenId

    ENS_RECORD[] public ENS_RECORD_ARR;
    
    address DaoDomain;
    address NFTDomain;
    address AnyLinkDomain;

    function setAuthorityContract(address _DaoDomain,address _NFTDomain,address _AnyLinkDomain) external onlyOwner{
        DaoDomain = _DaoDomain;
        NFTDomain = _NFTDomain;
        AnyLinkDomain = _AnyLinkDomain;
    }

    function _putENS_RECORD(ENS_RECORD memory ens_record) public returns(ENS_RECORD memory){
        // require(msg.sender == DaoDomain || msg.sender == NFTDomain || msg.sender == AnyLinkDomain,"no authority");
        ENS_RECORD_ARR.push(ens_record);
        return ens_record;
    }

    function _setProJectTeam(address sender,string memory domain, address adr) public {
        // require(msg.sender == DaoDomain || msg.sender == NFTDomain || msg.sender == AnyLinkDomain,"no authority");
        ProJectTeam[sender][domain] = adr;
    }

    function _setUserSubDomain(address sender,address adr,bytes32 label,uint256 tokenId) public {
        // require(msg.sender == DaoDomain || msg.sender == NFTDomain || msg.sender == AnyLinkDomain,"no authority");
        UserSubDomain[sender][adr][label] = tokenId;
    }

    function getENSRecordArrLength() public view returns(uint256){
        return ENS_RECORD_ARR.length;
    }

    function StorageDomainAddr() view external onlyOwner returns(address){
        return address(this);
    } 
}   