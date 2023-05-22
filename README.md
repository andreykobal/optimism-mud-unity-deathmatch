# Optimism Deathmatch with MUD Framework

<img width="400" alt="cover-logo-op-deathmatch" src="https://github.com/andreykobal/optimism-mud-unity-deathmatch/assets/19206978/c0dbaaf5-2ade-4f48-963a-2bf7a8c9c38d">

Optimism Deathmatch with MUD Framework is a powerful infrastructure tool for creating AAA deathmatch on-chain games using Unity. It combines the scalability and cost-efficiency of the Optimism network with the immersive gameplay and development capabilities of the MUD (Multi-User Dungeon) framework.

## Features
* ⚡ Seamless integration of Unity and MUD framework for a smooth game development experience.
* 🎮 High-performance gameplay with advanced features like hitscan weapons, recoil system, dynamic levels, and more.
* 📊 Efficient player management and global leaderboards with the LeaderboardCounterSystem smart contract.
* 🔄 Real-time updates and interactions using the MUD Template Unity for autogenerating C# definitions and subscribing to table updates.
* 🚀 Easy deployment to the Optimism network for testing and production environments.



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
