using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class PlayerSpawn : MonoBehaviour
{
    public static bool isJoined = false;
    public string startSceneName;

    List<int> unpairedCtrl = new List<int>{0,1,2,3,4};
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
            foreach (var i in unpairedCtrl)
            {
                if(Input.GetButtonDown("Fire1P" + i)){
                    playerSpawn();
                    unpairedCtrl.Remove(i);
                    pairedCtrl.Add(i);
                }
            }

            //if button1(X) && controller paired
            foreach (var i in pairedCtrl)
            {
                if(Input.GetButtonDown("Fire1P" + i)){
                    playerDestroy();
                    pairedCtrl.Remove(i);
                    unpairedCtrl.Add(i);
                }
            }
            
            //destroy player, controller unpaired

        }
        
    }

    void playerSpawn(){
        //instantiate new player 
        //instantiate player UI 
        //map controllers to player & UI
    }

    void playerDestroy(){
        
    }

    //distrbute UI in another manager

}
