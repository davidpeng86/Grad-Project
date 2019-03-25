using System.Collections;
using System.Collections.Generic;
using UnityEngine;

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
    }
}
