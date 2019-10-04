using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
public class player1ui : MonoBehaviour
{
    public Image hpbar;
    public Image sword;
    public Image shadow;
    public GameObject myplayer;
    // public int playerid;
    // Start is called before the first frame update
    private void Awake()
    {

    }
    void Start()
    {
        RigidbodyCharacter[] players = FindObjectsOfType(typeof(RigidbodyCharacter)) as RigidbodyCharacter[];
        // foreach (RigidbodyCharacter player in players)
        // {
        //     if (playerid == player.GetComponent<RigidbodyCharacter>().controllernumber)
        //     {
        //         myplayer = player.gameObject;
        //     }
        // }
    }

    // Update is called once per frame
    void Update()
    {
        if (myplayer != null)
        {
            hpbar.fillAmount = (float)myplayer.GetComponent<PlayerState>().currentHp / (float)myplayer.GetComponent<PlayerState>().hpMax;
            sword.fillAmount = (myplayer.GetComponent<RigidbodyCharacter>().sword_CD - myplayer.GetComponent<RigidbodyCharacter>().sword_count) / myplayer.GetComponent<RigidbodyCharacter>().sword_CD;
            shadow.fillAmount = (myplayer.GetComponent<RigidbodyCharacter>().duplicate_CD - myplayer.GetComponent<RigidbodyCharacter>().duplicate_count) / myplayer.GetComponent<RigidbodyCharacter>().duplicate_CD;
        }
    }
}
