using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BulletDetection : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        Destroy(gameObject.transform.parent.gameObject, 1.3f);
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnTriggerEnter(Collider other) {
        if(other.gameObject.layer == LayerMask.NameToLayer("player")){
            PlayerState state = other.gameObject.GetComponent<PlayerState>();
            state.isShown = true;
        }
    }
}
