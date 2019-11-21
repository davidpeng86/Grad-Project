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

    public int particleNum = 15;
    Vector3 particleSpawnPos;
    bool isSpawning = true;
    
    void Start()
    {
        rb = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
        if (isSpawning)
        {
            particleSpawnPos = gameObject.transform.position + gameObject.transform.up;
            for (int i = 0; i < particleNum; i++)
            {
                particle.InstantiateAsync(particleSpawnPos, Random.rotation);
            }
        }
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.tag != this.tag)
        {
            isSpawning = false;
            if (collision.gameObject.layer == LayerMask.NameToLayer("ground"))
            {
                detect.transform.position = new Vector3(transform.position.x, transform.position.y + 0.2f, transform.position.z);
                detect.SetActive(true);
                detect.transform.parent = null;
                rb.isKinematic = true;

                for (int i = 0; i < 3 * particleNum; i++)
                {
                    particle.InstantiateAsync(particleSpawnPos, Random.rotation);
                }

                Destroy(gameObject);
            }
            else if (collision.gameObject.layer == LayerMask.NameToLayer("player") && collision.gameObject.tag != this.tag)
            {
                PlayerState stateChange = collision.gameObject.GetComponent<PlayerState>();
                stateChange.currentHp -= 1;
                stateChange.TakeDamage();
                Destroy(gameObject);
            }
            else
            {
                print(collision.gameObject.name);

                detect.transform.position = new Vector3(transform.position.x, transform.position.y + 0.2f, transform.position.z);
                detect.SetActive(true);
                detect.transform.parent = null;

                rb.isKinematic = true;
                for (int i = 0; i < 4 * particleNum; i++)
                {
                    particle.InstantiateAsync(particleSpawnPos, Random.rotation);
                }
                Destroy(gameObject, 0.5f);

            }
        }

        
    }
}
