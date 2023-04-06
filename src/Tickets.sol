// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IPerks {
    function mint(address to, uint amount) external;
}

contract Ticket {
    IPerks immutable perks;
    mapping(address => mapping(uint16 => bool)) public userTicket;
    mapping(address => uint8[]) public allUserTickets;
    mapping(address => uint8) public totalTicketsPurchased;

    constructor(address _perks) {
        perks = IPerks(_perks);
    }

    function buyTickets(uint8[] memory tickets) external {
        uint8 length = uint8(tickets.length);
        for (uint16 i = 0; i < tickets.length; ++i) {
            require(!userTicket[msg.sender][tickets[i]], "already purchased");
            allUserTickets[msg.sender].push(tickets[i]);
            userTicket[msg.sender][tickets[i]] = true;
        }
        totalTicketsPurchased[msg.sender] = length;
    }

    function redeemPerks() external {
        uint8[] memory userTickets = allUserTickets[msg.sender];
        uint total;
        require(userTickets.length > 0, "buy tickets to redeem");
        for (uint i = userTickets.length; i > 0; i--) {
            uint random = uint(keccak256(abi.encode(userTickets[i - 1]))) %
                userTickets.length;
            total += random;
            userTicket[msg.sender][userTickets[i - 1]] = false;
        }
        totalTicketsPurchased[msg.sender] = 0;
        delete allUserTickets[msg.sender];
        perks.mint(msg.sender, total);
    }
}
