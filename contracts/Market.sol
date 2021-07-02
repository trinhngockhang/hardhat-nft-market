// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract Market is IERC721Receiver {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    address public piggyBank;
    address public token;
    address public nft;

    struct Item {
        address owner;
        uint256 tokenId;
        uint256 price;
        uint256 status; // 1: available, 2: sold, 3: cancle
    }

    mapping(uint256 => Item) public items;
    uint256 public numberItems;

    constructor(
        address _piggy,
        address _token,
        address _nft
    ) {
        token = _token;
        piggyBank = _piggy;
        nft = _nft;
    }
    function sender() view public returns (address) {
        return msg.sender;
    }
    function listItem(uint256 _tokenId, uint256 _price)
        public
        returns (uint256 id)
    {
        require(
            IERC721(nft).ownerOf(_tokenId) == msg.sender,
            "you are not own this token"
        );
        IERC721(nft).safeTransferFrom(msg.sender, address(this), _tokenId);
        id = numberItems;
        Item storage item = items[id];
        item.owner = msg.sender;
        item.tokenId = _tokenId;
        item.price = _price;
        item.status = 1;
        ++numberItems;
    }

    function cancelOrder(uint256 _itemId) public returns (bool) {
        Item storage item = items[_itemId];
        require(item.owner == msg.sender, "not the owner of this item");
        require(item.status == 1, "already on sale");

        IERC721(nft).safeTransferFrom(address(this), msg.sender, item.tokenId);

        item.status = 3;
        item.price = 0;
        return true;
    }

    function buy(uint256 _itemId, uint256 _amount) public returns (bool) {
        Item storage item = items[_itemId];
        require(item.owner != address(0), "item not exist");
		require(item.status == 1, 'item unavailable');

		require(_amount >= item.price, "invalid amount");
		IERC20(token).safeTransferFrom(msg.sender, item.owner, _amount);
		IERC721(nft).safeTransferFrom(address(this), msg.sender, item.tokenId);
		item.price = _amount;
		item.status = 2;
		return true;
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }
}
