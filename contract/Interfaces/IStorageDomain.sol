// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;

interface IStorageDomain{
    function setAuthorityContract(address _DaoDomain,address _NFTDomain,address _AnyLinkDomain) external;
    function putENS_RECORD(uint256 _index,address contractAddress,string memory domain) external;
    function setProJectTeam(address sender,string memory domain, address adr) external;
    function setUserSubDomain(address sender,address adr,bytes32 label,uint256 tokenId) external;
    function getENSRecordArrLength() external view returns(uint256);
    function getStorageDomainAddr() view external returns(address);
    function getProJectTeam(address sender,string memory domain) view external returns(address);
    function getUserSubDomain(address sender,address contractAddress,bytes32 label) view external returns(uint256);
    function getENS_RECORD_ARR_ContractAddress(uint256 index) view external returns(address);
    function getENS_RECORD_ARR_Domain(uint256 index) view external returns(string memory);
    function getDomainByAddress(address tokenAddress) view external returns(string memory);

}