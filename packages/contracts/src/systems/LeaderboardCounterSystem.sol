// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { System } from "@latticexyz/world/src/System.sol";
import { IStore } from "@latticexyz/store/src/IStore.sol";
import { Counter } from "./Tables.sol";

bytes32 constant KillsKey = bytes32(uint256(0x060D));
bytes32 constant DeathsKey = bytes32(uint256(0x060E));
bytes32 constant ScoreKey = bytes32(uint256(0x060F));
bytes32 constant SingletonKey = bytes32(uint256(0x060D));

contract LeaderboardCounterSystem is System {
    struct Player {
        string name;
        uint32 kills;
        uint32 deaths;
        uint32 score;
    }

    mapping(address => Player) private players;
    IncrementSystem private incrementSystem;

    constructor(address _incrementSystemAddress) {
        incrementSystem = IncrementSystem(_incrementSystemAddress);
    }

    /**
     * @dev Increment the kills counter for the player and return the updated value.
     */
    function incrementKills() public returns (uint32) {
        uint32 newValue = incrementSystem.increment();
        updatePlayerKills(newValue);
        return newValue;
    }

    /**
     * @dev Increment the deaths counter for the player and return the updated value.
     */
    function incrementDeaths() public returns (uint32) {
        uint32 newValue = incrementSystem.increment();
        updatePlayerDeaths(newValue);
        return newValue;
    }

    /**
     * @dev Increment the score counter for the player and return the updated value.
     * @param value The value to add to the score.
     */
    function incrementScore(uint32 value) public returns (uint32) {
        uint32 newValue = incrementSystem.increment() + (value * 100); // Multiply the value by 100
        updatePlayerScore(newValue);
        return newValue;
    }

    /**
     * @dev Update the kills counter for the player.
     * @param newValue The new value for the kills counter.
     */
    function updatePlayerKills(uint32 newValue) private {
        address playerAddress = msg.sender;
        Player storage player = players[playerAddress];
        player.kills = newValue;
    }

    /**
     * @dev Update the deaths counter for the player.
     * @param newValue The new value for the deaths counter.
     */
    function updatePlayerDeaths(uint32 newValue) private {
        address playerAddress = msg.sender;
        Player storage player = players[playerAddress];
        player.deaths = newValue;
    }

    /**
     * @dev Update the score counter for the player.
     * @param newValue The new value for the score counter.
     */
    function updatePlayerScore(uint32 newValue) private {
        address playerAddress = msg.sender;
        Player storage player = players[playerAddress];
        player.score = newValue / 100; // Divide the score by 100 to get the actual value
    }

    /**
     * @dev Update the name of the player.
     * @param newName The new name for the player.
     */
    function updatePlayerName(string memory newName) public {
        address playerAddress = msg.sender;
        Player storage player = players[playerAddress];
        player.name = newName;
        // TO DO: Get photon nick name
    }

    /**
     * @dev Get the statistics of a player.
     * @param playerAddress The address of the player.
     * @return name The name of the player.
     * @return kills The number of kills by the player.
     * @return deaths The number of deaths of the player.
     * @return score The score of the player.
     */
    function getPlayerStats(address playerAddress) public view returns (string memory name, uint32 kills, uint32 deaths, uint32 score) {
        Player storage player = players[playerAddress];
        return (player.name, player.kills, player.deaths, player.score);
    }

    /**
     * @dev Get the global leaderboard.
     * @return addresses The addresses of the top players on the leaderboard.
     * @return scores The scores of the top players on the leaderboard.
     */
    function getGlobalLeaderboard() public view returns (address[] memory addresses, uint32[] memory scores) {
        uint32[] memory score = new uint32[](1);
        score[0] = Counter.get(ScoreKey);
        address[] memory addresses = new address[](1);
        addresses[0] = msg.sender;
        return (addresses, scores);
    }
}

abstract contract IncrementSystem {
    function increment() public virtual returns (uint32);
}

