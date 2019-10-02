using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class PlayerSpawn : MonoBehaviour
{
    public static bool isJoined = false;
    public string startSceneName;
    public List<GameObject> playerz = new List<GameObject>();
    public List<GameObject> UI = new List<GameObject>();

    List<LinkedPlayer> spawnedPlayers = new List<LinkedPlayer>();
    List<PlayerState> playerState = new List<PlayerState>();
    List<int> unpairedCtrl = new List<int>{0,1,2,3};
    List<int> pairedCtrl = new List<int>{};
    Scene scene;
    // Start is called before the first frame update
    void Start()
    {
        scene = SceneManager.GetActiveScene();
        
    }

    // Update is called once per frame
    void Update()
    {
        //if in start scene
        if (scene.name == startSceneName){
            //if player press button0(A) && controller not paired yet
            foreach(var i in unpairedCtrl)
            {
                if(Input.GetButtonDown("Fire1P" + i)){
                    spawnedPlayers.Add(new LinkedPlayer(i,SpawnPlayer(i)));
                    pairedCtrl.Add(i);
                    unpairedCtrl.Remove(i);
                    print("linked \n" + "paired " + pairedCtrl.Count + "\n" + "unpaired " + unpairedCtrl.Count);
                }
            }

            //if button1(X) && controller paired
            foreach (var i in pairedCtrl)
            { 
                //destroy player, controller unpaired
                if (Input.GetButtonDown("Fire1P" + i)){
                    DestroyPlayer(i);
                    unpairedCtrl.Add(i);
                    pairedCtrl.Remove(i);
                    print("unlink \n" + "paired " + pairedCtrl.Count + "\n" + "unpaired " + unpairedCtrl.Count);
                }
            }
        }

        foreach(var i in spawnedPlayers){
            TrackPlayerState(i.player);
        }
        Winner();
        
    }

    GameObject SpawnPlayer(int i){
        GameObject spawnee = Instantiate(playerz[i]);
        return spawnee;
        //instantiate new player 
        //instantiate player UI 
        //map controllers to player & UI
    }

    void DestroyPlayer(int j){
        for(int i = 0; i < spawnedPlayers.Count; i++){
            if(j == spawnedPlayers[i].controllerNum){
                Destroy(spawnedPlayers[i].player);
                spawnedPlayers.Remove(spawnedPlayers[i]);
                return;
            }
        }
    }

    void TrackPlayerState(GameObject player){
        playerState.Add(player.GetComponent<PlayerState>());
    }

    void Winner(){
        for (int i = 0; i < playerState.Count; i++) {
            if(playerState.Count <= 1){
                playerState[i].win = true;
            }
            if(playerState[i].isDead == true){
                playerState.Remove(playerState[i]);
            }
        }
    }
    //distrbute UI in another manager

}

public class LinkedPlayer{
    public int controllerNum;
    public GameObject player;
    public LinkedPlayer(int i, GameObject p){
        controllerNum = i;
        player = p;
    }

}
