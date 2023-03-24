// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;

import "./PassCard.sol";

contract Factory{

address[] public PassCardAdr;
mapping (address => string) DaoNft;

function deployNewERC721Token(string memory name, string memory symbol)
        public
        returns (address)
    {
        PassCard passcard = new PassCard(name, symbol);
        DaoNft[address(passcard)] = name;
        PassCardAdr.push(address(passcard));
        return address(passcard);
    }

function getDaoContract() view public returns(address[] memory) {
    return PassCardAdr;
}
}

