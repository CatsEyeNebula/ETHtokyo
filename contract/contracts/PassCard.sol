// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract PassCard is ERC721, Pausable, Ownable, ERC721Burnable {
    using Counters for Counters.Counter;
    
    event AddressSet(address[] addr);

    Counters.Counter private _tokenIdCounter;

    constructor(string memory name,string memory symbol) ERC721(name, symbol) {}

    address[] public airdropAdr;
    mapping (address => uint256[]) public tokenids;
    bool public revokable;
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override {
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
        tokenids[to].push(tokenId);
    }

    function getallTokenId(address _owner) view public returns(uint256[] memory) {
        return  tokenids[_owner];
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
    ) public {
        require(airdropAdr.length > 0,"address null");
        uint256 len = airdropAdr.length;
        for (uint256 i; i < len; i++) {
            safeMint(airdropAdr[i]);
        }
        
        delete airdropAdr;
    }
}

