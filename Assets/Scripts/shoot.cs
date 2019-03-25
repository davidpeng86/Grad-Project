using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class shoot : MonoBehaviour {

    public GameObject bullet;

    [SerializeField]
    float shootForce = 20f;
    [SerializeField]
    float atkRadius = 2f;
    [SerializeField]
    GameObject gunPoint;
    Animator anim;
	// Use this for initialization
	void Start () {
		anim = GetComponent<Animator>();
	}
	
	// Update is called once per frame
	void Update () {
        if (Input.GetButtonDown("Fire1") && gunPoint != null) {
            GameObject temp_bullet =
                Instantiate(bullet, gunPoint.transform.position, gunPoint.transform.rotation);

            temp_bullet.transform.Rotate(Vector3.left * 90f, Space.Self);


            Rigidbody temp_rigidbody = temp_bullet.GetComponent<Rigidbody>();
            temp_rigidbody.AddRelativeForce(Vector3.down * shootForce);

            Debug.Log("shot");

            Destroy(temp_bullet,2);
        }

        if(Input.GetKeyDown(KeyCode.Mouse1)){
            Collider[] colliders = Physics.OverlapSphere(transform.position, atkRadius);
            if(colliders.Length <= 0) return;
            anim.SetBool("enemy",false);
            anim.SetTrigger("attack");
            for (int i = 0; i < colliders.Length; i++){
                if (colliders[i].transform.root != transform){
                    if(colliders[i].gameObject.tag == "player"){
                        anim.SetBool("enemy",true);
                        PlayerState ps = colliders[i].GetComponent<PlayerState>();
                        ps.currentHp -= 3;
                    }
                    print(colliders[i].gameObject.name);
                }
            }
                
        }
	}


}
