// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFT is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor(string memory name, string memory symbol)
        ERC721(name, symbol)
    {}
    function mint(address _to) public returns (uint256) {
        _tokenIds.increment();

        uint256 newNftId = _tokenIds.current();
        _mint(_to, newNftId);

        return newNftId;
    }
}
