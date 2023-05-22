# Optimism Deathmatch with MUD Framework

<img width="400" alt="cover-logo-op-deathmatch" src="https://github.com/andreykobal/optimism-mud-unity-deathmatch/assets/19206978/c0dbaaf5-2ade-4f48-963a-2bf7a8c9c38d">

# Optimism Deathmatch :crossed_swords:

Welcome to Optimism Deathmatch, the ultimate competitive gaming experience powered by the cutting-edge MUD (Multi-User Dungeon) framework and deployed on the Optimism network. Prepare yourself for fast-paced gameplay, advanced features, and a seamless gaming experience like never before. :video_game:

## Features :rocket:

- :boom: Multiple Gameplay Modes: Engage in intense battles across various modes, including Battle Royale, Elimination, and Deathmatch.
- :gun: Hitscan Weapons with Projectile Data Ring Buffer: Wield powerful hitscan weapons that provide precise and instantaneous targeting.
- :earth_americas: Headless Server Instance: Configure and customize your gaming experience with ease using command-line arguments.
- :dart: Weapon Dynamics and Recoil System: Feel the authentic kickback of each weapon with dynamic dispersion, recoil, and recoil patterns.
- :arrows_counterclockwise: Tick-Accurate Animation System: Immerse yourself in fluid and realistic animations that synchronize perfectly with the game's tick system.
- :zap: Advanced Interest Management: Experience seamless gameplay with advanced interest management, reducing latency and enhancing performance.
- :joystick: Advanced Input Processing: Enjoy precise and responsive controls with custom look smoothing for an intuitive and immersive gaming experience.
- :muscle: Health & Damage System: Strategize and manage your health as you engage in fierce battles.
- :dagger: Projectile Piercing: Explore the dynamic world of projectile physics with piercing capabilities.
- :world_map: Semi-Procedurally Generated Levels: Explore unique and ever-changing battlegrounds with semi-procedurally generated levels.
- :fire: And much more: Discover a plethora of additional features, including item boxes, pickups, grenades, jetpacks, spectator mode, camera shake, and matchmaking.

## Smart Contract: LeaderboardCounterSystem :trophy:

The LeaderboardCounterSystem smart contract is the heart of the Optimism Deathmatch project. It manages player statistics and global leaderboards, ensuring a fair and transparent gaming experience for all participants. The smart contract offers the following functionality:

- :arrow_up: Incrementing Kills: Players can increment their kill count, contributing to their overall performance in the game.
- :arrow_down: Incrementing Deaths: Players can increment their death count, providing insights into their resilience and gameplay strategies.
- :trophy: Incrementing Score: A scoring mechanism allows players to earn points based on their in-game achievements, climbing up the leaderboard.
- :bar_chart: Player Statistics: The smart contract stores and manages player statistics, including name, kill count, death count, and score.
- :globe_with_meridians: Global Leaderboard: Players can access the global leaderboard to see the top players and their corresponding scores.

## Getting Started :rocket:

To get started with Optimism Deathmatch, follow these steps:

1. :octocat: Clone this repository.
2. :wrench: Install the necessary prerequisites such as Git, Foundry, Node.js, pnpm, and Unity.
3. :computer: Set up the MUD Template Unity by following the instructions provided in the tutorial.
4. :gear: Customize and integrate the Fusion BR sample with the MUD framework to align with your project's vision.
5. :rocket: Deploy the LeaderboardCounterSystem smart contract to the Optimism network using the provided deployment instructions.
6. :globe_with_meridians: Configure the network settings and endpoints in your project to connect to Optimism Goerli.
7. :building_construction: Build and run the project in Unity to experience the adrenaline-pumping Optimism Deathmatch.

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
bash
Copy code
git clone <repository_url>
Install Dependencies:

Navigate to the project's root directory:

bash
Copy code
cd optimism-deathmatch
Install the project dependencies using pnpm:

Copy code
pnpm install
Configure Optimism Network:

In the packages/contracts directory, create a .env file with the following content:
rust
Copy code
ETH_NETWORK='localOptimism'
LATTICE_SERVER='http://localhost:8000'
Deploy Contracts to Optimism:

Deploy the contracts to the Optimism network by running the following command:
arduino
Copy code
pnpm run deploy:optimism
Start the Optimism Environment:

Start the Optimism environment using Foundry:
Copy code
foundry up
Run the Unity Game:

Open the Unity project in Unity Editor.
Open the main scene (packages/client/Assets/Scenes/Main.unity).
Press the play button to start the game.
Congratulations! Your Optimism Deathmatch project is now deployed on the Optimism network, and you can enjoy playing and testing it in the Unity game environment.

Note: Make sure to properly set the ChainID and RPC URLs in the NetworkManager component in Unity to connect to the Optimism network.

Enjoy the future of competitive gaming with Optimism Deathmatch!
