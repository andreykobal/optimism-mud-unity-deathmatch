// using System;
// using Cysharp.Threading.Tasks;
// using IWorld.ContractDefinition;
// using mud.Unity;
// using UniRx;
// using DefaultNamespace;
// using UnityEngine;
// using ObservableExtensions = UniRx.ObservableExtensions;

// public class LeaderboardManager : MonoBehaviour
// {
//     private IDisposable _playerStatsSub;
//     private IDisposable _globalLeaderboardSub;
//     private NetworkManager _net;

//     // Start is called before the first frame update
//     void Start()
//     {
//         _net = NetworkManager.Instance;
//         _net.OnNetworkInitialized += SubscribeToPlayerStats;
//         _net.OnNetworkInitialized += SubscribeToGlobalLeaderboard;
//     }

//     private void SubscribeToPlayerStats(NetworkManager _)
//     {
//         _playerStatsSub = ObservableExtensions.Subscribe(PlayerTable.OnRecordUpdate().ObserveOnMainThread(), OnPlayerStatsUpdate);
//     }

//     private void SubscribeToGlobalLeaderboard(NetworkManager _)
//     {
//         _globalLeaderboardSub = ObservableExtensions.Subscribe(LeaderboardCounterSystem.GetGlobalLeaderboardEvent().ObserveOnMainThread(), OnGlobalLeaderboardUpdate);
//     }

//     private void OnPlayerStatsUpdate(PlayerTableUpdate update)
//     {
//         var currentValue = update.TypedValue.Item1;
//         if (currentValue == null) return;

//         var playerName = currentValue.name;
//         var kills = currentValue.kills;
//         var deaths = currentValue.deaths;
//         var score = currentValue.score;

//         // Update UI or perform other actions based on the player's stats
//     }

//     private void OnGlobalLeaderboardUpdate(LeaderboardCounterSystem.GetGlobalLeaderboardEventResponse response)
//     {
//         var addresses = response.ReturnValue1;
//         var scores = response.ReturnValue2;

//         // Update UI or perform other actions based on the global leaderboard
//     }

//     private void Update()
//     {
//         if (Input.GetMouseButtonDown(0))
//         {
//             // Call the appropriate functions to update player stats or perform other actions
//             // For example:
//             // SendIncrementTxAsync().Forget();
//             // updatePlayerName("NewName");
//         }
//     }

//     private async UniTaskVoid SendIncrementTxAsync()
//     {
//         try
//         {
//             await _net.worldSend.TxExecute<IncrementFunction>();
//         }
//         catch (Exception ex)
//         {
//             // Handle your exception here
//             Debug.LogException(ex);
//         }
//     }

//     private async void updatePlayerName(string newName)
//     {
//         try
//         {
//             await _net.worldSend.TxExecute<UpdatePlayerNameFunction>(newName);
//         }
//         catch (Exception ex)
//         {
//             // Handle your exception here
//             Debug.LogException(ex);
//         }
//     }

//     private void OnDestroy()
//     {
//         _playerStatsSub?.Dispose();
//         _globalLeaderboardSub?.Dispose();
//     }
// }
