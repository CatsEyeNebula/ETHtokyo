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
    
    address public DaoDomain;
    address public NFTDomain;
    address public AnyLinkDomain;

    function setAuthorityContract(address _DaoDomain,address _NFTDomain,address _AnyLinkDomain) external onlyOwner{
        DaoDomain = _DaoDomain;
        NFTDomain = _NFTDomain;
        AnyLinkDomain = _AnyLinkDomain;
    }

    function putENS_RECORD(uint256 _index,address contractAddress,string memory domain) external {
        require(msg.sender == DaoDomain || msg.sender == NFTDomain || msg.sender == AnyLinkDomain,"no authority");
        ENS_RECORD memory ens_record = ENS_RECORD(_index,contractAddress,domain);
        ENS_RECORD_ARR.push(ens_record);
    }

    function setProJectTeam(address sender,string memory domain, address adr) external {
        require(msg.sender == DaoDomain || msg.sender == NFTDomain || msg.sender == AnyLinkDomain,"no authority");
        ProJectTeam[sender][domain] = adr;
    }

    function setUserSubDomain(address sender,address adr,bytes32 label,uint256 tokenId) external {
        require(msg.sender == DaoDomain || msg.sender == NFTDomain || msg.sender == AnyLinkDomain,"no authority");
        UserSubDomain[sender][adr][label] = tokenId;
    }

    function getENSRecordArrLength() public view returns(uint256){
        return ENS_RECORD_ARR.length;
    }

    function getStorageDomainAddr() view external returns(address){
        return address(this);
    } 

    function getProJectTeam(address sender,string memory domain) view external returns(address){
        return ProJectTeam[sender][domain];
    }

    function getUserSubDomain(address sender,address contractAddress,bytes32 label) view external returns(uint256){
        return UserSubDomain[sender][contractAddress][label];
    }

    function getENS_RECORD_ARR_ContractAddress(uint256 index) view external returns(address){
        return ENS_RECORD_ARR[index].contractAddress;
    }

    function getENS_RECORD_ARR_Domain(uint256 index) view external returns(string memory){
        return ENS_RECORD_ARR[index].domain;
    }

    function getDomainByAddress(address tokenAddress) view external returns (string memory) {
        uint256 len = getENSRecordArrLength();
        for (uint256 i = 0; i < len; i++) {
        if (ENS_RECORD_ARR[i].contractAddress == tokenAddress) {
            return ENS_RECORD_ARR[i].domain;
        }
    }
    return ""; 
}   

}   