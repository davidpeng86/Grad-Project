using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System;
public class PlayerManager : MonoBehaviour
{

    List<GameObject> players = new List<GameObject>();
    List<PlayerState> playerState = new List<PlayerState>();
    public GameObject winUI, spotLight = null;
    public Light mainLight;

    bool spotlightLit = false, isWin = false;
    void Start()
    {
        if(GameObject.FindGameObjectsWithTag("player0").Length > 0)
            players.Add(GameObject.FindGameObjectsWithTag("player0")[0]);

        if(GameObject.FindGameObjectsWithTag("player1").Length > 0){
            players.Add(GameObject.FindGameObjectsWithTag("player1")[0]);}

        if(GameObject.FindGameObjectsWithTag("player2").Length > 0){
            players.Add(GameObject.FindGameObjectsWithTag("player2")[0]);}
        
        if(GameObject.FindGameObjectsWithTag("player3").Length > 0)
            players.Add(GameObject.FindGameObjectsWithTag("player3")[0]);

        
        foreach (GameObject player in players) {
            playerState.Add(player.GetComponent<PlayerState>());
        }
    }

    // Update is called once per frame
    void Update()
    {
        for (int i = 0; i < playerState.Count; i++) {
            if(playerState.Count <= 1 && !isWin ){
                playerState[i].win = true;
                spotLight.transform.position = new Vector3(playerState[i].transform.position.x,spotLight.transform.position.y, playerState[i].transform.position.z);
                spotLight.transform.parent = playerState[i].transform;
                //spotLight.SetActive(true);
                spotlightLit = true;    
            }
            if(playerState[i].isDead == true){
                playerState.Remove(playerState[i]);
            }
        }

        if (spotlightLit) {
            isWin = true;
            print("isLit");
            spotlightLit = false;
            StartCoroutine(WinnerSpotlight());
        }
    }

    void ShowWinScreen() {
        winUI.SetActive(true);
    }

    IEnumerator WinnerSpotlight() {
        for (int i = 0; i < 3 * 60; i++)
        {
            mainLight.spotAngle -= 79f / 180f;
            spotLight.GetComponent<Light>().spotAngle += 30f / 180f;
            yield return new WaitForFixedUpdate();
        }
        ShowWinScreen();
    }
}
