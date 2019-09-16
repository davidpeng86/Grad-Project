using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
public class StartSceneManager : MonoBehaviour
{
    public GameObject player;
    PlayerState ps;
    // Start is called before the first frame update
    void Start()
    {
        ps = player.GetComponent<PlayerState>();
    }

    // Update is called once per frame
    void Update()
    {
        if(ps.win == true){
            SceneManager.LoadScene("gameRoom_01");
        }
    }
}
