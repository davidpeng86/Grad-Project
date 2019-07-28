using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class rotatingLight : MonoBehaviour {

	public float RotationX = 0f;
	public float RotationY = 0f;
	public float RotationZ = 0f;

	// Use this for initialization
	void Start () {
	}
	
	// Update is called once per frame
	void Update () {
		transform.Rotate(Vector3.right * RotationX * Time.deltaTime, Space.World);
		transform.Rotate(Vector3.up * RotationY * Time.deltaTime, Space.World);
		transform.Rotate(Vector3.forward * RotationZ * Time.deltaTime, Space.World);
	}
}
