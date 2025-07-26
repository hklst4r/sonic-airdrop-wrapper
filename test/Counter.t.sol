// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {SonicAirdropWrapper, IERC1155} from "../src/sonic_airdrop_wrapper.sol";

contract CounterTest is Test {
    SonicAirdropWrapper public sonicAirdropWrapper;

    // a random airdrop nft holder
    address airdropTokenHolder = 0xD8a30dBB3b8B204B6D8bb800D0f2865d07DC904C;


    function setUp() public {
        vm.createSelectFork("https://rpc.soniclabs.com");
        sonicAirdropWrapper = new SonicAirdropWrapper();
    }


    function test_mint_redeem() public {
        // console log all balances with description before mint
        console.log("BEFORE MINT");
        console.log("airdropTokenHolder balance", sonicAirdropWrapper.balanceOf(airdropTokenHolder));
        console.log("user balance", sonicAirdropWrapper.balanceOf(airdropTokenHolder));
        console.log("airdropTokenHolder nft balance", IERC1155(sonicAirdropWrapper.nftAddress()).balanceOf(airdropTokenHolder, sonicAirdropWrapper.season()));
        console.log("user nft balance", IERC1155(sonicAirdropWrapper.nftAddress()).balanceOf(airdropTokenHolder, sonicAirdropWrapper.season()));
        console.log("airdropTokenHolder wAIRDROP-1 balance", sonicAirdropWrapper.balanceOf(airdropTokenHolder));
        console.log("user wAIRDROP-1 balance", sonicAirdropWrapper.balanceOf(airdropTokenHolder));

        // mint
        vm.startPrank(airdropTokenHolder);
        IERC1155(sonicAirdropWrapper.nftAddress()).setApprovalForAll(address(sonicAirdropWrapper), true);
        uint256 balance = IERC1155(sonicAirdropWrapper.nftAddress()).balanceOf(airdropTokenHolder, sonicAirdropWrapper.season());
        sonicAirdropWrapper.mint(balance);
        assertEq(sonicAirdropWrapper.balanceOf(airdropTokenHolder), balance);
        assertEq(IERC1155(sonicAirdropWrapper.nftAddress()).balanceOf(airdropTokenHolder, sonicAirdropWrapper.season()), 0);

        // console log all balances with description after mint
        console.log("AFTER MINT");
        console.log("airdropTokenHolder balance", sonicAirdropWrapper.balanceOf(airdropTokenHolder));
        console.log("user balance", sonicAirdropWrapper.balanceOf(airdropTokenHolder));
        console.log("airdropTokenHolder nft balance", IERC1155(sonicAirdropWrapper.nftAddress()).balanceOf(airdropTokenHolder, sonicAirdropWrapper.season()));
        console.log("user nft balance", IERC1155(sonicAirdropWrapper.nftAddress()).balanceOf(airdropTokenHolder, sonicAirdropWrapper.season()));
        console.log("airdropTokenHolder wAIRDROP-1 balance", sonicAirdropWrapper.balanceOf(airdropTokenHolder));
        console.log("user wAIRDROP-1 balance", sonicAirdropWrapper.balanceOf(airdropTokenHolder));

        // redeem
        balance = sonicAirdropWrapper.balanceOf(airdropTokenHolder);
        sonicAirdropWrapper.redeem(balance);
        assertEq(sonicAirdropWrapper.balanceOf(airdropTokenHolder), 0);
        assertEq(IERC1155(sonicAirdropWrapper.nftAddress()).balanceOf(airdropTokenHolder, sonicAirdropWrapper.season()), balance);

        // console log all balances with description after redeem
        console.log("AFTER REDEEM");
        console.log("airdropTokenHolder balance", sonicAirdropWrapper.balanceOf(airdropTokenHolder));
        console.log("airdropTokenHolder nft balance", IERC1155(sonicAirdropWrapper.nftAddress()).balanceOf(airdropTokenHolder, sonicAirdropWrapper.season()));
        console.log("airdropTokenHolder wAIRDROP-1 balance", sonicAirdropWrapper.balanceOf(airdropTokenHolder));
    }

    function test_mint_more_than_balance() public {
        // Attempt to mint more than the available balance
        vm.startPrank(airdropTokenHolder);
        IERC1155(sonicAirdropWrapper.nftAddress()).setApprovalForAll(address(sonicAirdropWrapper), true);
        uint256 balance = IERC1155(sonicAirdropWrapper.nftAddress()).balanceOf(airdropTokenHolder, sonicAirdropWrapper.season());
        uint256 excessiveAmount = balance + 1; // More than available balance
        vm.expectRevert();
        sonicAirdropWrapper.mint(excessiveAmount);

        vm.stopPrank();
    }

    function test_redeem_more_than_balance() public {
        // Attempt to redeem more than the available balance
        vm.startPrank(airdropTokenHolder);
        IERC1155(sonicAirdropWrapper.nftAddress()).setApprovalForAll(address(sonicAirdropWrapper), true);
        // mint
        uint256 balance = IERC1155(sonicAirdropWrapper.nftAddress()).balanceOf(airdropTokenHolder, sonicAirdropWrapper.season());
        sonicAirdropWrapper.mint(balance);
        vm.stopPrank();

        // redeem
        vm.startPrank(airdropTokenHolder);
        balance = sonicAirdropWrapper.balanceOf(airdropTokenHolder);
        uint256 excessiveAmount = balance + 1; // More than available balance
        try sonicAirdropWrapper.redeem(excessiveAmount) {
            revert("Expected redeem to fail due to insufficient balance");
        } catch Error(string memory reason) {
            assertEq(reason, "Insufficient balance");
        }
        vm.stopPrank();
    }
}
