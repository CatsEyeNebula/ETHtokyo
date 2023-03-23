// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "./SetSubDomain.sol";

contract PassCard is ERC721, Pausable, Ownable, ERC721Burnable, ERC721Enumerable {
    using Counters for Counters.Counter;
    
    event AddressSet(address[] addr);

    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("PassCard", "PCD") {}

    address[] public airdropAdr;
    SetSubDomain public subdomain;

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external  override {
        require(_isApprovedOrOwner(tx.origin, tokenId), "ERC721: caller is not token owner or approved");

        _transfer(from, to, tokenId);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function safeMint(address to) internal onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function getSum(uint256[] calldata _arr) public pure returns (uint sum) {
        for (uint i = 0; i < _arr.length; i++) sum = sum + _arr[i];
    }

    function setAirDropAddr(address[] calldata _address) external{
        airdropAdr = _address;
        emit AddressSet(airdropAdr);
    }

    function multiTransferToken(
    ) external {
        require(airdropAdr.length > 0,"address null");
        uint256 len = airdropAdr.length;
        for (uint256 i; i < len; i++) {
            safeMint(airdropAdr[i]);
        }

        delete airdropAdr;
    }
}

