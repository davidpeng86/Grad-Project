using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class playerMovement : MonoBehaviour {

    public float rotateSpeed = 5f;
	[SerializeField]
	float moveForce  = 1000f;
	float h_input;
	float v_input;

    Rigidbody rb;
	// Use this for initialization
	void Start () {
		rb = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update () {
		
		h_input = Input.GetAxis("Horizontal");
		v_input = Input.GetAxis("Vertical");

        if(h_input!=0 || v_input!=0){
        Vector3 newPosition = new Vector3(Mathf.Lerp(0, h_input, Time.deltaTime/10), transform.position.y, Mathf.Lerp(0, v_input, Time.deltaTime/10));
        Vector3 dir = newPosition - transform.position;
        Quaternion Q_rotation = Quaternion.LookRotation(dir);
        transform.rotation = Quaternion.Lerp(transform.rotation, Q_rotation, rotateSpeed * Time.deltaTime);
        
        rb.AddForce(transform.forward * moveForce * Time.deltaTime);
        }


    }
}
