pragma solidity >=0.8.0;

import { System } from "@latticexyz/world/src/System.sol";
import { IStore } from "@latticexyz/store/src/IStore.sol";
import { Counter } from "../codegen/Tables.sol";

bytes32 constant KillsKey = bytes32(uint256(0x060D));
bytes32 constant DeathsKey = bytes32(uint256(0x060E));

contract LeaderboardCounterSystem is System {
    struct Player {
        string name;
        uint32 kills;
        uint32 deaths;
    }

    mapping(address => Player) private players;

    function incrementKills() public returns (uint32) {
        bytes32 key = KillsKey;
        uint32 counter = Counter.get(key);
        uint32 newValue = counter + 1;
        Counter.set(key, newValue);
        updatePlayerKills(newValue);
        return newValue;
    }

    function incrementDeaths() public returns (uint32) {
        bytes32 key = DeathsKey;
        uint32 counter = Counter.get(key);
        uint32 newValue = counter + 1;
        Counter.set(key, newValue);
        updatePlayerDeaths(newValue);
        return newValue;
    }

    function updatePlayerKills(uint32 newValue) private {
        address playerAddress = msg.sender;
        Player storage player = players[playerAddress];
        player.kills = newValue;
    }

    function updatePlayerDeaths(uint32 newValue) private {
        address playerAddress = msg.sender;
        Player storage player = players[playerAddress];
        player.deaths = newValue;
    }

    function getPlayerStats(address playerAddress) public view returns (string memory, uint32, uint32) {
        Player storage player = players[playerAddress];
        return (player.name, player.kills, player.deaths);
    }
}
