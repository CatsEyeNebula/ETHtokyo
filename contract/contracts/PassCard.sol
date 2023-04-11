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

    constructor(string memory name,string memory symbol,bool _revokable,bool _transferable) ERC721(name, symbol) {
        revokable = _revokable;
        transferable = _transferable;
    }

    address[] public airdropAdr;
    mapping (address => uint256[]) public tokenids;
    bool public immutable revokable;
    bool public immutable transferable;

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override {
        require(transferable,"this passcard is not transferable");
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

    function setAirDropAddr(address[] calldata _address) public onlyOwner{
        airdropAdr = _address;
        emit AddressSet(airdropAdr);
    }

    function burn(uint256 tokenId) public onlyOwner override{
        require(revokable,"this passcard is not revokable");
        require(_isApprovedOrOwner(_msgSender(), tokenId), "caller is not token owner or approved");
        _burn(tokenId);
    }

    function multiTransferToken(
    ) public onlyOwner{
        require(airdropAdr.length > 0,"address null");
        uint256 len = airdropAdr.length;
        for (uint256 i; i < len; i++) {
            safeMint(airdropAdr[i]);
        }
        
        delete airdropAdr;
    }
}

