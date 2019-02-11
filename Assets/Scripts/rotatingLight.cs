using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class rotatingLight : MonoBehaviour {

	public float rotateSpeed = 15f;
	Rigidbody rb;

	// Use this for initialization
	void Start () {
		rb = GetComponent<Rigidbody>();
	}
	
	// Update is called once per frame
	void Update () {
		transform.Rotate(Vector3.up * rotateSpeed * Time.deltaTime, Space.World);
	}
}
