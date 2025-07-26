// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {IERC1155} from "../lib/openzeppelin-contracts/contracts/token/ERC1155/IERC1155.sol";
import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";


contract SonicAirdropWrapper is ERC20 {
    address public immutable nftAddress = 0xE1401171219FD2fD37c8C04a8A753B07706F3567;
    uint public immutable season = 1;

    constructor() ERC20("Wrapped Sonic Airdrop Season 1", "wAIRDROP-1") {
    }

    // mint wAIRDROP-1
    function mint(uint256 amount) external {
        IERC1155(nftAddress).safeTransferFrom(msg.sender, address(this), season, amount, "");
        // The rest of the logic is in the onERC1155Received function
    }

    // redeem wAIRDROP-1
    function redeem(uint256 amount) external {
        // burn user's wAIRDROP-1
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        _burn(msg.sender, amount);
        // mint nft, no reentrancy issue because the token is already burned
        IERC1155(nftAddress).safeTransferFrom(address(this), msg.sender, season, amount, "");
    }

    // mint wAIRDROP-1 when this contract receives nft
    function onERC1155Received(address operator, address fromAddress, uint256 id, uint256 amount, bytes memory data) external returns (bytes4) {
        require(msg.sender == nftAddress, "Invalid sender");
        require(id == season, "Invalid season");
        _mint(fromAddress, amount);
        return this.onERC1155Received.selector;
    }

    receive() external payable {
        revert("This contract does not accept ETH");
    }

    fallback() external payable {
        revert("This contract does not accept ETH");
    }
}
