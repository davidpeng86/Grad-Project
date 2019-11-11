using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
public class StartSceneManager : MonoBehaviour
{
    List<GameObject> players = new List<GameObject>();
    public GameObject play;
    PlayerSpawn playerSpawn;

    // Start is called before the first frame update
    void Awake()
    {
        playerSpawn = GetComponent<PlayerSpawn>();
    }

    // Update is called once per frame
    void Update()
    {
        if (play == null) {
            if (playerSpawn.UI.Count > 1) {
                SceneManager.LoadScene("Desert");
            }
            else
                print("needs more players");
        }
            
        
        
    }
}
