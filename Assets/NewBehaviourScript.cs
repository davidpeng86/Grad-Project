using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NewBehaviourScript : MonoBehaviour
{
    Rigidbody rb;
    private void Start(){
        rb = GetComponent<Rigidbody>();
    }
    // Update is called once per frame
    private void FixedUpdate()
    {
        var v_spd = Input.GetAxisRaw("Vertical");
        var h_spd = Input.GetAxisRaw("Horizontal");
        var newPosition = new Vector3(h_spd, 0, v_spd);
        transform.LookAt(newPosition + transform.position);
        rb.velocity = newPosition * 5;
    }
}