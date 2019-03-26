using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerState : MonoBehaviour
{
    private int hpMax = 5;
    public int currentHp;
    public bool isDead;
    public bool win;


    // Start is called before the first frame update
    void Start()
    {
        currentHp = hpMax;
        isDead = false;
        win = false;
    }

    // Update is called once per frame
    void Update()
    {
        if (currentHp <= 0) {
            isDead = true;
            Destroy(gameObject);
        }
    }

    
}
