// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {ERC20} from "../src/ERC20.sol";

contract ERC20Test is Test {
    ERC20 public token;

    address user1 = makeAddr("user1");
    address user2 = makeAddr("user2");

    string _name = "BlockchainUNNToken";
    string _symbol = "BNT";

    function setUp() public {
        token = new ERC20(_name, _symbol, 18);
        token._mint(user1, 1000);
    }

    function test_token_name() public {
        assertEq(token.name(), _name);
    }

    function test_token_symbol() public {
        assertEq(token.symbol(), _symbol);
    }

    function test_token_decimals() public {
        assertEq(token.decimals(), 18);
    }

    function test_mint_token_user1() public {
        // mint 1000 of BNT token to  user1
        assertEq(token.balanceOf(user1), 1000);
    }

    function test_transfer_to_user2() public {
        // user1 to send 200 to user2
        // user1 has approve user2 first

        vm.startPrank(user1);
        token.approve(user2, 200);
        vm.stopPrank();

        vm.startPrank(user2);
        token.transferFrom(user1, user2, 200);
        assertEq(token.balanceOf(user1), 800);
        assertEq(token.balanceOf(user2), 200);
        vm.stopPrank();
    }

    function test_total_supply() public {
        assertEq(token.totalSupply(), 1000);
    }

    // helper function to create address
    function mkaddr(string memory name) public returns (address) {
        address addr = address(
            uint160(uint256(keccak256(abi.encodePacked(name))))
        );
        vm.label(addr, name);
        return addr;
    }
}
