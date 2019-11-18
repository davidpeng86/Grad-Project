using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AddressableAssets;
public class bullet : MonoBehaviour
{
    // Start is called before the first frame update
    public GameObject detect;
    private Rigidbody rb;
    public AssetReference particle;
    void Start()
    {
        rb = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.layer == LayerMask.NameToLayer("player") && collision.gameObject.tag != this.tag) {
            PlayerState stateChange = collision.gameObject.GetComponent<PlayerState>();
            stateChange.currentHp -= 1;
            stateChange.TakeDamage();
            Destroy(gameObject);
        }

        if (collision.gameObject.layer == LayerMask.NameToLayer("ground")) {
            detect.transform.position = new Vector3(transform.position.x, transform.position.y + 0.2f, transform.position.z);
            detect.SetActive(true);
            detect.transform.parent = null;
            rb.isKinematic = true;
            Destroy(gameObject);
        }
    }
}
