using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class PlayerSpawn : MonoBehaviour
{
    public GameObject UIcanvas;
    public GameObject UIPrefab;
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
        if (scene.name != startSceneName){
            PlaceUI();
        }
    }

    void Update()
    {
        if (scene.name == startSceneName){
            //if player press button0(A) && controller not paired yet
            for (int i = 0; i < unpairedCtrl.Count; i++){
                if(Input.GetButtonDown("Fire1P" + unpairedCtrl[i])){
                    int controller = unpairedCtrl[i];
                    LinkedPlayer newBorn = new LinkedPlayer(controller,SpawnPlayer(controller));
                    spawnedPlayers.Add(newBorn);
                    PairUI(newBorn);
                    PairCtrl(controller);
                    PlaceUI();
                    print("linked \n" + "paired " + pairedCtrl.Count + "\n" + "unpaired " + unpairedCtrl.Count);
                    return;
                }
            }

            //if button1(X) && controller paired
            for (int i = 0; i < pairedCtrl.Count; i++){
                if (Input.GetButtonDown("Fire1P" + pairedCtrl[i])){
                    int controller = pairedCtrl[i];
                    DestroyUI(controller);
                    PlaceUI();
                    DestroyPlayer(controller);
                    UnpairCtrl(controller);
                    print("unlink \n" + "paired " + pairedCtrl.Count + "\n" + "unpaired " + unpairedCtrl.Count);
                    return;
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
        //instantiate player UI
        //map controllers to player & UI
    }

    void PairCtrl(int i){
        pairedCtrl.Add(i);
        if(unpairedCtrl.Count != 0)
            unpairedCtrl.Remove(i);
    }

    void UnpairCtrl(int i){
        unpairedCtrl.Add(i);
        if(pairedCtrl.Count != 0)
            pairedCtrl.Remove(i);
    }

    void DestroyPlayer(int j){
        for(int i = 0; i < spawnedPlayers.Count; i++){
            if(j == spawnedPlayers[i].controllerNum){
                Destroy(spawnedPlayers[i].player);
                spawnedPlayers.Remove(spawnedPlayers[i]);
            }
        }
    }

    void DestroyUI(int j){
        for(int i = 0; i < UI.Count; i++){
            if(UI[i].GetComponent<player1ui>().myplayer.controllerNum == j){
                Destroy(UI[i]);
                UI.RemoveAt(i);
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
    void PairUI(LinkedPlayer linkedPlayer){
        GameObject spawnUI = Instantiate(UIPrefab);
        spawnUI.GetComponent<player1ui>().myplayer = linkedPlayer;
        spawnUI.transform.parent = UIcanvas.transform;
        spawnUI.transform.localScale = new Vector3(0.5f, 0.5f, 1);
        UI.Add(spawnUI);
    }

    void PlaceUI(){
        switch(UI.Count){
            case 0:
                break;
            case 1:
                UI[0].transform.position = new Vector3(Screen.width/2, 50, 0);
                break;
            case 2:
                UI[0].transform.position = new Vector3(Screen.width/3, 50, 0);
                UI[1].transform.position = new Vector3(2*Screen.width/3, 50, 0);
                break;
            case 3:
                break;
            case 4:
                break;
        }
    }

    void MatchUIColor() {


    }
}

public class LinkedPlayer{
    public int controllerNum;
    public GameObject player;
    public LinkedPlayer(int i, GameObject p){
        controllerNum = i;
        player = p;
    }

}
