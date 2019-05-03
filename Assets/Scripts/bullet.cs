using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class bullet : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.layer == LayerMask.NameToLayer("player") && collision.gameObject.tag != this.tag) {
            PlayerState stateChange = collision.gameObject.GetComponent<PlayerState>();
            stateChange.currentHp -= 1;
            Destroy(gameObject);
        }
    }
}
