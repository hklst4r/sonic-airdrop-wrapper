// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {SonicAirdropWrapper} from "../src/sonic_airdrop_wrapper.sol";

contract SonicAirdropWrapperScript is Script {
    SonicAirdropWrapper public sonicAirdropWrapper;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        sonicAirdropWrapper = new SonicAirdropWrapper();

        vm.stopBroadcast();
    }
}
