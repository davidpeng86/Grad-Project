using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
public class StartSceneManager : MonoBehaviour
{
    List<GameObject> players = new List<GameObject>();
    public GameObject play;
    PlayerState ps;
    // Start is called before the first frame update
    void Start()
    {
    }

    // Update is called once per frame
    void Update()
    {
        if(play == null)
            SceneManager.LoadScene("Desert");
        
    }
}
