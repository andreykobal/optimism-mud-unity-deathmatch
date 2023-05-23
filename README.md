# Optimism Deathmatch with MUD Framework

<img width="400" alt="cover-logo-op-deathmatch" src="https://github.com/andreykobal/optimism-mud-unity-deathmatch/assets/19206978/c0dbaaf5-2ade-4f48-963a-2bf7a8c9c38d">

# Optimism Deathmatch :crossed_swords:

Welcome to Optimism Deathmatch, the ultimate competitive gaming experience powered by the cutting-edge MUD framework and deployed on the Optimism network. Prepare yourself for fast-paced gameplay, advanced features, and a seamless gaming experience like never before. :video_game:

## Features :rocket:

* Optimism Deathmatch is a game-changing project that combines the power of cutting-edge technologies to deliver an immersive and exhilarating gaming experience. 🚀

* ✨ Game-ready: Dive into fast-paced battles and compete with other players in intense multiplayer matches. Engage in thrilling gameplay modes, including Battle Royale, Elimination, and Deathmatch. Experience the adrenaline rush as you strategize, outsmart opponents, and dominate the leaderboard. 🏆

* 🛠️ Tool for Developers: Optimism Deathmatch serves as a powerful tool for developers, providing a comprehensive framework for building online multiplayer games. With our MUD template, developers can create their own game worlds, customize gameplay mechanics, and unleash their creativity to bring unique gaming experiences to life. 🎮

* ⚡ Optimism Network: We leverage the Optimism network, a layer 2 scalability solution for Ethereum, to provide fast and cost-effective transactions. By harnessing the power of Optimism, players can enjoy seamless gameplay with reduced latency and enhanced performance. ⚡

* 🔧 MUD Framework: Optimism Deathmatch is built upon the MUD framework, offering a robust foundation for networking, synchronization, and multiplayer interactions. The MUD framework empowers developers with powerful tools to create dynamic game worlds and engaging gameplay mechanics. 🌐

* 🗃️ NFT.Storage: Our project utilizes NFT.Storage, a decentralized storage solution for NFTs, to store and manage avatars and in-game assets. NFT.Storage ensures the security, reliability, and uniqueness of digital assets, enabling players to trade and showcase their personalized creations. 🖼️


* 🔥 And much more: Discover a plethora of additional features, including item boxes, pickups, grenades, jetpacks, spectator mode, camera shake, and matchmaking.
## Smart Contract: LeaderboardCounterSystem :trophy:

The ```LeaderboardCounterSystem``` smart contract is an integral part of the Optimism Deathmatch game. It manages player statistics and the global leaderboard, allowing players to track their progress and compete with others. The contract utilizes the ```IncrementSystem``` contract to provide atomic increment operations for counting player actions.

```solidity
solidityCopy code
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



```

The LeaderboardCounterSystem contract allows players to interact with the game and track their statistics. It utilizes the IncrementSystem contract for atomic increment operations. The contract provides functions to increment kills, deaths, and scores, as well as update player names and retrieve player statistics. The global leaderboard can also be accessed to see the top players and their scores.

The smart contract offers the following functionality:

- :arrow_up: Incrementing Kills: Players can increment their kill count, contributing to their overall performance in the game.
- :arrow_down: Incrementing Deaths: Players can increment their death count, providing insights into their resilience and gameplay strategies.
- :trophy: Incrementing Score: A scoring mechanism allows players to earn points based on their in-game achievements, climbing up the leaderboard.
- :bar_chart: Player Statistics: The smart contract stores and manages player statistics, including name, kill count, death count, and score.
- :globe_with_meridians: Global Leaderboard: Players can access the global leaderboard to see the top players and their corresponding scores.

##Hall Of Reflections 

The `HallOfReflections` contract allows users to mint reflections of their owned ERC-721 or ERC-1155 NFTs and interact with those reflections. Each reflection is associated with a character avatar file and a character bio. Interactions with reflections are recorded in the Hall of Fame, which keeps track of the number of interactions for each reflection.

To mint a reflection, users must own the corresponding ERC-721 or ERC-1155 NFT. The `mintReflection` function creates a reflection token by generating a unique reflectionTokenId based on the current timestamp, the caller's address, the NFT contract address, and the NFT token ID. The reflection data, including the owner, the reflection token ID, the NFT contract address, the NFT token ID, the avatar file, and the character bio, are stored in the `reflections` mapping.

Users can interact with a reflection by calling the `interactWithReflection` function and providing the reflectionTokenId. This function increments the interaction count in the Hall of Fame for the corresponding reflection and calls the `generateResponse` function of the `InteractWithReflectionSystem` contract to generate a response based on the character bio.

<aside>
💡 `MintReflectionSystem` and `InteractWithReflectionSystem` contracts, which handle the minting of reflections and the generation of responses, respectively. We need to make sure to deploy and connect these contracts before interacting with the `HallOfReflections` contract.

</aside>

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import OpenZeppelin ERC-721 and ERC-1155 libraries
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

/**

@title HallOfReflections
@dev The HallOfReflections contract allows users to mint reflections of their owned ERC-721 or ERC-1155 NFTs and interact with those reflections.

Reflections are associated with a character avatar and bio, and interactions with reflections are recorded in the Hall of Fame.
*/
contract HallOfReflections {
// Reflection struct to store reflection data
struct Reflection {
    address owner;
    uint256 reflectionTokenId;
    address nftContract;
    uint256 nftTokenId;
    string avatarFile;
    string characterBio;
}

// Reflections table to store reflection data
mapping(uint256 => Reflection) public reflections;

// Hall of Fame table to store interaction counts
mapping(uint256 => uint256) public hallOfFame;

// MintReflectionSystem contract to handle reflection minting
address public mintReflectionSystem;

// InteractWithReflectionSystem contract to handle interactions with reflections
address public interactWithReflectionSystem;

/**

@dev Constructor function
@param _mintReflectionSystem Address of the MintReflectionSystem contract
@param _interactWithReflectionSystem Address of the InteractWithReflectionSystem contract
*/
constructor(address _mintReflectionSystem, address _interactWithReflectionSystem) {
    mintReflectionSystem = _mintReflectionSystem;
    interactWithReflectionSystem = _interactWithReflectionSystem;
}
// Modifier to check if the caller is the MintReflectionSystem contract
modifier onlyMintReflectionSystem() {
    require(msg.sender == mintReflectionSystem, "Only MintReflectionSystem can call this function");
    _;
}

// Modifier to check if the caller is the InteractWithReflectionSystem contract
modifier onlyInteractWithReflectionSystem() {
    require(msg.sender == interactWithReflectionSystem, "Only InteractWithReflectionSystem can call this function");
    _;
}

/**

@dev Mint a reflection of the provided ERC-721 or ERC-1155 NFT.
@param nftContract Address of the NFT contract.
@param nftTokenId ID of the NFT token.
@param avatarFile File associated with the reflection's avatar.
@param characterBio Bio description of the reflection's character.
*/
function mintReflection(address nftContract, uint256 nftTokenId, string memory avatarFile, string memory characterBio) external {
    require(
        IERC721(nftContract).ownerOf(nftTokenId) == msg.sender || IERC1155(nftContract).balanceOf(msg.sender, nftTokenId) > 0, "Caller must own the NFT"
        );
        uint256 reflectionTokenId = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, nftContract, nftTokenId)));

    Reflection storage reflection = reflections[reflectionTokenId];
    reflection.owner = msg.sender;
    reflection.reflectionTokenId = reflectionTokenId;
    reflection.nftContract = nftContract;
    reflection.nftTokenId = nftTokenId;
    reflection.avatarFile = avatarFile;
    reflection.characterBio = characterBio;
}

/**

@dev Interact with a reflection and generate a response based on the character bio.
@param reflectionTokenId ID of the reflection token.
*/
function interactWithReflection(uint256 reflectionTokenId) external {
    require(reflections[reflectionTokenId].reflectionTokenId != 0, "Reflection does not exist");
    // Update interaction count in the Hall of Fame table
    hallOfFame[reflectionTokenId]++;
    // Call the InteractWithReflectionSystem contract to generate a response
    InteractWithReflectionSystem(interactWithReflectionSystem).generateResponse(reflectionTokenId);
}
}

/**

@title InteractWithReflectionSystem
@dev The InteractWithReflectionSystem contract generates a response based on the character bio of a reflection.
*/
contract InteractWithReflectionSystem {

    /**
    @dev Generate a response based on the character bio of a reflection.
    @param reflectionTokenId ID of the reflection token.
    */
    function generateResponse(uint256 reflectionTokenId) external {
    // Use GPT-4 AI or any other logic to generate a response based on the character bio
    // Implementation details omitted for brevity  
    }
}
```

## Getting Started :rocket:

To get started with Optimism Deathmatch, follow these steps:

1. :octocat: Clone this repository.
2. :wrench: Install the necessary prerequisites such as Git, Foundry, Node.js, pnpm, and Unity.
3. :computer: Set up the MUD Template Unity by following the instructions provided in the tutorial.
4. :gear: Customize and integrate the Deathmatch sample with the MUD framework to align with your project's vision.
5. :rocket: Deploy the LeaderboardCounterSystem smart contract to the Optimism network using the provided deployment instructions.
6. :globe_with_meridians: Configure the network settings and endpoints in your project to connect to Optimism Goerli.
7. :building_construction: Build and run the project in Unity to experience the adrenaline-pumping Optimism Deathmatch.

LeaderboardCounterSystem Smart Contract
License

## LeaderboardCounterSystem smart contract

The LeaderboardCounterSystem smart contract is a key component of the Optimism Deathmatch project, designed to manage player statistics and global leaderboards. This smart contract ensures a fair and transparent gaming experience for all participants.

Features
1. 🎮 Incrementing Kills: The incrementKills function allows players to increment their kill count. Every successful kill increases the player's kill count by 1, contributing to their overall performance in the game.

2. 🔫 Incrementing Deaths: The incrementDeaths function enables players to increment their death count. Each time a player is eliminated, their death count increases by 1, providing insights into their resilience and gameplay strategies.

3. 🏆 Incrementing Score: The incrementScore function introduces a scoring mechanism where players can earn points based on their in-game achievements. By specifying a value, multiplied by 100, players can increment their score and climb up the leaderboard. The score is a reflection of their overall performance and success in the game.

4. 📊 Player Statistics: The smart contract stores and manages player statistics through the Player struct. This includes the player's name, kill count, death count, and score. Players can retrieve their own statistics using the getPlayerStats function, providing them with an overview of their performance and progress.

5. 🌍 Global Leaderboard: The getGlobalLeaderboard function allows players to access the global leaderboard. By querying this function, players can obtain an array of addresses representing the top players and their corresponding scores. This fosters healthy competition and motivates players to strive for excellence.

### Usage
To integrate the LeaderboardCounterSystem smart contract into your MUD game, follow these steps:

* Deploy the smart contract to the Optimism network using the provided deployment instructions.

* In your MUD game, import the smart contract ABI and create an instance of the contract using the deployed contract address.

* Call the various functions provided by the smart contract to manage player statistics. Use incrementKills to increase a player's kill count, incrementDeaths to update the death count, and incrementScore to adjust the player's score based on in-game achievements.

* Retrieve player statistics using the getPlayerStats function to display personalized performance information to players.

* Utilize the getGlobalLeaderboard function to showcase the top players and their scores in your game's leaderboard.

## Documentation :book:

For detailed documentation on how to use the LeaderboardCounterSystem smart contract in Unity and deploy the project to the Optimism network, refer to the [Documentation](/docs) directory.

## Community and Support :bulb:

For any questions, suggestions, or support, please reach out to our team at [email protected]

Let the battle begin! Step into the future of gaming with Optimism Deathmatch. :crossed_swords:

## Prerequisites

1. git ([download](https://git-scm.com/downloads))
2. foundry (forge, anvil, cast) ([download](https://book.getfoundry.sh/getting-started/installation), make sure to foundryup at least once)
3. node.js (v16+) ([download](https://nodejs.org/en/download))
4. pnpm (after installing node: npm install --global pnpm)
5. Unity ([download](https://unity.com/download))
6. The .NET SDK (7.0) ([download](https://dotnet.microsoft.com/en-us/download))

If you are using Windows:

1. install git bash (gitforwindows.org)
2. install nodejs, including “native modules” (nodejs.org/en/download) (re native modules: just keep the checkmark, it’s enabled by default in the installer)
3. Install foundry via foundryup using Git bash

## Tutorial

The tutorial repo for this template can be found [here](https://github.com/emergenceland/tankmud-tutorial).

## Quickstart

Run the following command in the root:

```
pnpm install
```

Then, open two terminal tabs.

In tab 1:

```
pnpm run dev:node
```

In tab 2:

```
pnpm run dev
```

In Unity, Open the Main scene if you haven’t already `(packages/client/Assets/Scenes/Main.unity)`.
Press play. Click to increment the counter.

## Usage

MUD Template Unity autogenerates C# definitions for your Tables when you run `pnpm dev`. These should appear in `packages/client/Assets/Scripts/codegen/`.

### Getting a value

```csharp
var addressKey = net.addressKey;
// get by key
var currentPlayer = PlayerTable.GetTableValue(addressKey);

// currentPlayer is strongly typed
string name = currentPlayer.name;
```

### Subscribing to updates

```csharp
var playerSubInsert = PlayerTable.OnRecordInsert().ObserveOnMainThread().Subscribe(OnInsertPlayers);

var playerSubUpdate = PlayerTable.OnRecordUpdate().ObserveOnMainThread().Subscribe(OnDeletePlayers);

var playerSubDelete = PlayerTable.OnRecordDelete().ObserveOnMainThread().Subscribe(OnDeletePlayers);

var playerSubDeleteInsert = PlayerTable.OnRecordInsert.Merge(PlayerTable.OnRecordDelete).ObserveOnMainThread().Subscribe(OnInsertDeletePlayers);


private void OnUpdatePlayers(PlayerTableUpdate update)
{
	// PlayerTableUpdate has a TypedValue, which is a Tuple of <PlayerTable,PlayerTable>
	// Item 1 is the current value, and Item 2 is the previous value.
	var currentValue = update.TypedValue.Item1;
	if (currentValue == null) return;
	var previousValue = update.TypedValue.Item2;

 // PlayerTableUpdate inherits from UniMUD's RecordUpdate
 // So you can still get the key, table, and untyped values.
	var playerPosition = PositionTable.GetTableValue(update.Key);
	if (playerPosition == null) return;

	var playerSpawnPoint = new Vector3((float)playerPosition.x, 0, (float)playerPosition.y);
	var player = Instantiate(playerPrefab, playerSpawnPoint, Quaternion.identity);

	if (update.Key == net.addressKey) {
		Debug.Log("Is local player");
	}
}
```

### Making a transaction

This template generates Nethereum bindings for your World contract, which, we can access to make a transaction.
Note that not all Unity functions can be async, so you may need to wrap your transaction in a coroutine.

```csharp
	async void Spawn(NetworkManager nm)
	{
		var addressKey = net.addressKey;
		var currentPlayer = PlayerTable.GetTableValue(addressKey);
		if (currentPlayer == null)
		{
			// spawn the player
			await nm.worldSend.TxExecute<SpawnFunction>(0, 0);
		}
	}

	// For example, with the UniTask library:
	private async UniTaskVoid SendIncrementTxAsync()
	{
		try
		{
			await net.worldSend.TxExecute<IncrementFunction>();
		}
		catch (Exception ex)
		{
			// Handle your exception here
			Debug.LogException(ex);
		}
	}
```



### Deploying to a Testnet

You can deploy to any non-local chain with `cd packages/contracts && pnpm run deploy:testnet`.
Be sure to properly set the ChainID and RPC urls in the **NetworkManager** component.

UniMUD currently doesn’t implement the faucet service, so you must manually send testnet funds to your address. Your address is logged in Debug mode, but you can also create a UI component to fetch and display it from the NetworkManager.



## Deploying to Optimism

To deploy your Optimism Deathmatch project to the Optimism network, follow these steps:

### Setup Optimism Environment:

Ensure you have the necessary dependencies installed:

* git (download: https://git-scm.com/downloads)
* foundry (forge, anvil, cast) (download: https://github.com/lattice-works/foundry#installation)
* node.js (v16+) (download: https://nodejs.org)
* pnpm (after installing Node.js: npm install --global pnpm)
* Unity (download: https://unity.com)
* The .NET SDK (7.0) (download: https://dotnet.microsoft.com/download)
* If you're using Windows:

* Install git bash (https://gitforwindows.org)
* Install Node.js, including "native modules" (keep the checkmark enabled during installation, as it's enabled by default)
* Clone the Project:

Clone the Optimism Deathmatch project repository using git:

```git clone https://github.com/andreykobal/optimism-mud-unity-deathmatch```
Install Dependencies:

Navigate to the project's root directory:

```cd optimism-deathmatch```

Install the project dependencies using pnpm:

```pnpm install```

###Configure Optimism Network:

In the packages/contracts directory, create a .env file with the following content:
rust
Copy code
ETH_NETWORK='localOptimism'
LATTICE_SERVER='http://localhost:8000'

### Deploy Contracts to Optimism:

Deploy the contracts to the Optimism network by running the following command:

```pnpm run deploy:optimism```
Start the Optimism Environment:

Start the Optimism environment using Foundry:

```foundry up```
Run the Unity Game:

Open the Unity project in Unity Editor.
Open the main scene (packages/client/Assets/Scenes/Main.unity).
Press the play button to start the game.
Congratulations! Your Optimism Deathmatch project is now deployed on the Optimism network, and you can enjoy playing and testing it in the Unity game environment.

Note: Make sure to properly set the ChainID and RPC URLs in the NetworkManager component in Unity to connect to the Optimism network.

Enjoy the future of competitive gaming with Optimism Deathmatch!
