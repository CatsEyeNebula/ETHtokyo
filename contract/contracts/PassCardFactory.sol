// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;

import "./PassCard.sol";
import  "./StorageDomain.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract PassCardFactory is Ownable,StorageDomain{
    // function setStorafeDomainAdr(address StorageDomainAdr) public onlyOwner{
    //     storagedomain = StorageDomain(StorageDomainAdr);
    // }
    function _deployPassCard(
        string memory name,
        string memory symbol,
        bool revokable,
        bool transferable
    ) internal returns (address) {
        PassCard passcard = new PassCard(name, symbol,revokable,transferable);
        ENS_RECORD memory ens_record;
        ens_record.index = 0;
        ens_record.contractAddress = address(passcard);
        ens_record.domain = name;
        _putENS_RECORD(ens_record);
        _setProJectTeam(msg.sender, name, ens_record.contractAddress);
        return address(passcard);
    }

    function _getPassCardFactoryAddr() view internal onlyOwner returns(address){
        return address(this);
    } 

    // function _getStorageDomainAddr() view internal onlyOwner returns(address){
    //     return StorageDomain.StorageDomainAddr();
    // }
}
