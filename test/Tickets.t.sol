// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Tickets.sol";
import "../src/mocks/perks.sol";

contract TicketsTese is Test {
    Ticket public ticket;
    Perks public perks;

    function setUp() public {
        //deploying perks Token
        perks = new Perks();
        //deploying tickets
        ticket = new Ticket(address(perks));
        perks.transferOwnership(address(ticket));
    }

    function testredeem() public {
        vm.expectRevert("buy tickets to redeem");
        ticket.redeemPerks();
    }
}
