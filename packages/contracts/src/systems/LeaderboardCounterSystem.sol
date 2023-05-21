pragma solidity >=0.8.0;

import { System } from "@latticexyz/world/src/System.sol";
import { IStore } from "@latticexyz/store/src/IStore.sol";
import { Counter } from "../codegen/Tables.sol";

bytes32 constant SingletonKey = bytes32(uint256(0x060D));

contract LeaderboardCounterSystem is System {
    function incrementKills() public returns (uint32) {
        bytes32 key = bytes32(uint256(0x060D)); // Use a unique key for kills
        uint32 counter = Counter.get(key);
        uint32 newValue = counter + 1;
        Counter.set(key, newValue);
        return newValue;
    }

    function incrementDeaths() public returns (uint32) {
        bytes32 key = bytes32(uint256(0x060E)); // Use a unique key for deaths
        uint32 counter = Counter.get(key);
        uint32 newValue = counter + 1;
        Counter.set(key, newValue);
        return newValue;
    }
}
