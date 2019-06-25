using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OnOff : MonoBehaviour
{
    public GameObject GO;
    // Start is called before the first frame update
    bool active;
    void Start()
    {
        active = true;
    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetKeyDown(KeyCode.Space)){
            active = !active;
            GO.gameObject.SetActive(active);
        }
    }
}
