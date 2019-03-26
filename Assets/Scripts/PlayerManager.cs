using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
public class PlayerManager : MonoBehaviour
{
    GameObject[] players;
    List<PlayerState> playerState = new List<PlayerState>();
    // Start is called before the first frame update
    void Start()
    {
        players = GameObject.FindGameObjectsWithTag("player");
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
