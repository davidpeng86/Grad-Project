using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class shoot : MonoBehaviour {

    [SerializeField]
    float shootForce = 20f;
    [SerializeField]
    GameObject gunPoint;
    
    public GameObject bullet;
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
        if (Input.GetKeyDown("space")) {
            GameObject temp_bullet =
                Instantiate(bullet, gunPoint.transform.position, gunPoint.transform.rotation);

            temp_bullet.transform.Rotate(Vector3.left * 90f, Space.Self);


            Rigidbody temp_rigidbody = temp_bullet.GetComponent<Rigidbody>();
            temp_rigidbody.AddRelativeForce(Vector3.down * shootForce);
            Debug.Log("shot");

            StartCoroutine(CountDestroy(temp_bullet));
        }
	}

    IEnumerator CountDestroy(GameObject obj){

        yield return new WaitForSeconds(2);
        Destroy(obj);
    }

}
