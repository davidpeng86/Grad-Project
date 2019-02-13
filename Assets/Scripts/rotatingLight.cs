using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class rotatingLight : MonoBehaviour {

	public float rotateSpeed = 15f;

	// Use this for initialization
	void Start () {
	}
	
	// Update is called once per frame
	void Update () {
		transform.Rotate(Vector3.up * rotateSpeed * Time.deltaTime, Space.World);
	}
}
