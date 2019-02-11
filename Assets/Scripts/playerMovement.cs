using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class playerMovement : MonoBehaviour {

	[SerializeField]
	float moveForce  = 10f;
	Vector3 speed;
	float h_input;
	float v_input;

	[SerializeField]
	float maxSpeed;
	float negMaxSpeed;

	Rigidbody rb;
	// Use this for initialization
	void Start () {
		rb = GetComponent<Rigidbody>();
	}
	
	// Update is called once per frame
	void Update () {
		negMaxSpeed = -1 * maxSpeed;
		h_input = moveForce * Input.GetAxis("Horizontal");
		Debug.Log("h  " + h_input);
		v_input = moveForce * Input.GetAxis("Vertical");
		Debug.Log("v  "+ v_input);
		rb.AddForce(transform.right * h_input * Time.deltaTime);
		rb.AddForce(transform.forward * v_input * Time.deltaTime);
		// speed = new Vector3(Mathf.Clamp(rb.velocity.x,maxSpeed,negMaxSpeed),
		// 					rb.velocity.y,
		// 					Mathf.Clamp(rb.velocity.z,maxSpeed,negMaxSpeed));

		//rb.velocity = speed;
	}
}
