// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {IERC1155} from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract SonicAirdropWrapper is ERC20 {
    address public immutable nftAddress = 0xE1401171219FD2fD37c8C04a8A753B07706F3567;
    uint public immutable season = 1;

    constructor() ERC20("Wrapped Sonic Airdrop Season 1", "wAIRDROP-1") {
    }

    function mint(uint256 amount) public {
        IERC1155(nftAddress).safeTransferFrom(msg.sender, address(this), season, amount, "");
    }


    // function redeem
    function redeem(uint256 amount) public {
        // burn user's wAIRDROP-1
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        _burn(msg.sender, amount);
        // mint nft
        IERC1155(nftAddress).safeTransferFrom(address(this), msg.sender, season, amount, "");
    }




    function onERC1155Received(address operator, address fromAddress, uint256 id, uint256 amount, bytes memory data) public virtual override returns (bytes4) {
        require(id == season, "Invalid season");
        _mint(fromAddress, amount);
        return this.onERC1155Received.selector;
    }
}
