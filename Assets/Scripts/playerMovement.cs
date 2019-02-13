using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class playerMovement : MonoBehaviour {

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

        Vector3 newposition = new Vector3(Mathf.Lerp(0, h_input, Time.deltaTime), 0.0f, Mathf.Lerp(0, v_input, Time.deltaTime));
        transform.LookAt(newposition + transform.position);

        if (h_input != 0 || v_input!= 0)
        rb.AddForce(transform.forward * moveForce * Time.deltaTime);


    }
}
