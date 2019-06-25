using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System;
public class PlayerManager : MonoBehaviour
{
    List<GameObject> players = new List<GameObject>();
    List<PlayerState> playerState = new List<PlayerState>();

    GameObject[] empty = Array.Empty<GameObject>();
    // Start is called before the first frame update
    void Start()
    {
        if(GameObject.FindGameObjectsWithTag("player").Length > 0)
        players.Add(GameObject.FindGameObjectsWithTag("player")[0]);

        if(GameObject.FindGameObjectsWithTag("player0").Length > 0)
        players.Add(GameObject.FindGameObjectsWithTag("player0")[0]);

        if(GameObject.FindGameObjectsWithTag("player1").Length > 0){
            players.Add(GameObject.FindGameObjectsWithTag("player1")[0]);}

        if(GameObject.FindGameObjectsWithTag("player2").Length > 0){
            players.Add(GameObject.FindGameObjectsWithTag("player2")[0]);}

        
        foreach (GameObject player in players) {
            playerState.Add(player.GetComponent<PlayerState>());
        }
    }

    // Update is called once per frame
    void Update()
    {
        for (int i = 0; i < playerState.Count; i++) {
            if(playerState.Count <= 1){
                playerState[i].win = true;
            }
            if(playerState[i].isDead == true){
                playerState.Remove(playerState[i]);
            }
        }
    }
}
