using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System;
public class PlayerManager : MonoBehaviour
{
    List<GameObject> players = new List<GameObject>();
    List<PlayerState> playerState = new List<PlayerState>();
    // Start is called before the first frame update
    void Start()
    {
        for(int i = 0; i<UnityEditorInternal.InternalEditorUtility.tags.Length; i++){
            Debug.Log(UnityEditorInternal.InternalEditorUtility.tags[i]);
            if(UnityEditorInternal.InternalEditorUtility.tags[i].Contains("player")){
                if(GameObject.FindGameObjectsWithTag(UnityEditorInternal.InternalEditorUtility.tags[i]).Length>0){
                    players.Add(GameObject.FindGameObjectsWithTag(UnityEditorInternal.InternalEditorUtility.tags[i])[0]);
                }
                
            }
        }
        
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
