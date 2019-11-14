using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class PlayerSpawn : MonoBehaviour
{
    public GameObject UIcanvas;
    public GameObject UIPrefab;
    public string startSceneName;
    public List<GameObject> playerz = new List<GameObject>();
    public List<GameObject> UI = new List<GameObject>();

    public static List<LinkedPlayer> spawnedPlayers = new List<LinkedPlayer>();
    List<PlayerState> playerState = new List<PlayerState>();
    List<int> unpairedCtrl = new List<int>{0,1,2,3};
    List<int> pairedCtrl = new List<int>{};
    Scene scene;

    void Awake()
    { 
        scene = SceneManager.GetActiveScene();
        if (scene.name != startSceneName){
            for(int i = 0; i <spawnedPlayers.Count; i++){
                int j = spawnedPlayers[i].controllerNum;
                print(j);
                spawnedPlayers[i].player = SpawnPlayer(j);
                GameObject UI = PairUI(spawnedPlayers[i]);
                MatchUIColor(UI);
                PlaceUI();
                
            }
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
                    GameObject UI = PairUI(newBorn);
                    MatchUIColor(UI);
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
                    //DestroyPlayer(controller);
                    StartCoroutine(WaitToDestroy(controller));
                    // DestroyUI(controller);
                    // PlaceUI();
                    // UnpairCtrl(controller);
                    print("unlink \n" + "paired " + pairedCtrl.Count + "\n" + "unpaired " + unpairedCtrl.Count);
                    return;
                }
            }
        }

    }

    void LateUpdate(){
        foreach(var i in spawnedPlayers){
            TrackPlayerState(i.player);
        }
        Winner();
    }

    GameObject SpawnPlayer(int i){
        GameObject spawnee = Instantiate(playerz[i]);
        return spawnee;
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
                Animator playerAnimator = spawnedPlayers[i].player.GetComponent<Animator>();
                playerAnimator.SetTrigger("invisible");
                 if (playerAnimator.GetCurrentAnimatorStateInfo(0).IsName("DissolveOut"))
                {
                    // Avoid any reload.
                }
                Destroy(spawnedPlayers[i].player);
                spawnedPlayers.Remove(spawnedPlayers[i]);
            }
        }
    }

    IEnumerator WaitToDestroy(int j){
        for(int i = 0; i < spawnedPlayers.Count; i++){
            if(j == spawnedPlayers[i].controllerNum ){
                Animator playerAnimator = spawnedPlayers[i].player.GetComponent<Animator>();
                playerAnimator.speed = 2f;
                playerAnimator.SetTrigger("invisible");
                while (!playerAnimator.GetCurrentAnimatorStateInfo(0).IsName("DissolveOut")) {
                    yield return null;
                }
                //Now wait for them to finish
                while (playerAnimator.GetCurrentAnimatorStateInfo(0).IsName("DissolveOut")) {
                    yield return null;
                } 
                DestroyUI(j);
                PlaceUI();
                Destroy(spawnedPlayers[i].player);
                spawnedPlayers.Remove(spawnedPlayers[i]);
                UnpairCtrl(j);
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
        if(player!=null)
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

    GameObject PairUI(LinkedPlayer linkedPlayer){
        GameObject spawnUI = Instantiate(UIPrefab);
        spawnUI.GetComponent<player1ui>().myplayer = linkedPlayer;
        spawnUI.transform.parent = UIcanvas.transform;
        spawnUI.transform.localScale = new Vector3(0.3f, 0.3f, 1);
        UI.Add(spawnUI);
        return spawnUI;
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
                UI[0].transform.position = new Vector3(Screen.width/4, 50, 0);
                UI[1].transform.position = new Vector3(2*Screen.width/4, 50, 0);
                UI[2].transform.position = new Vector3(3*Screen.width/4, 50, 0);
                break;
            case 4:
                UI[0].transform.position = new Vector3(Screen.width/5, 50, 0);
                UI[1].transform.position = new Vector3(2*Screen.width/5, 50, 0);
                UI[2].transform.position = new Vector3(3*Screen.width/5, 50, 0);
                UI[3].transform.position = new Vector3(4*Screen.width/5, 50, 0);
                break;
        }
    }

    void MatchUIColor(GameObject gameObject) {
        player1ui playerUI = gameObject.GetComponent<player1ui>();
        switch (playerUI.myplayer.controllerNum){
            case 0:
                playerUI.setColor(new Color(125f/255f,1,0,1));
                break;
            case 1:
                playerUI.setColor(new Color(1,134f/255f,134f/255f,1));
                break;
            case 2:
                playerUI.setColor(new Color(60f/255f,70f/255f,1,1));
                break;
            case 3:
                playerUI.setColor(new Color(200f/255f,0,1,1));
                break;
        }
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
