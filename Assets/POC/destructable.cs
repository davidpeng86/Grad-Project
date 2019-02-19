using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class destructable : MonoBehaviour {
	
	public GameObject destroyedVersion;
	public float blastRadius;
	public float explosionPower;
	public LayerMask explosionLayer;

	private Collider[] hitColliders;
	void OnMouseDown(){
		Instantiate(destroyedVersion, transform.position, transform.rotation);
		Destroy(gameObject);
		Explode(transform.position);
	}

	void Explode(Vector3 explosionCenter){
		hitColliders = Physics.OverlapSphere(explosionCenter, blastRadius, explosionLayer);

		foreach (Collider hitCol in hitColliders)
		{
			hitCol.GetComponent<Rigidbody>().isKinematic = false;
			hitCol.GetComponent<Rigidbody>().AddExplosionForce(explosionPower,explosionCenter,blastRadius,1,ForceMode.Impulse);
		}
	}
}
