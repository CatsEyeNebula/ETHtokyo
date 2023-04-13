// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;

import "./PassCard.sol";
import "../Interfaces/IStorageDomain.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract PassCardFactory is Ownable{
    IStorageDomain public storagedomain;
    constructor(address _storagemainAddr){
        storagedomain = IStorageDomain(_storagemainAddr);
    }
    function _deployPassCard(
        string memory name,
        string memory symbol,
        bool revokable,
        bool transferable
    ) internal returns (address) {
        PassCard passcard = new PassCard(name, symbol,revokable,transferable);
        storagedomain.putENS_RECORD(0, address(passcard), name);
        storagedomain.setProJectTeam(msg.sender, name, address(passcard));
        return address(passcard);
    }

    function _getPassCardFactoryAddr() view internal onlyOwner returns(address){
        return address(this);
    } 
}
