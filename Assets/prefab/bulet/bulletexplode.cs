using UnityEngine;

public class bulletexplode : MonoBehaviour
{
    public GameObject particle;
    float timer = 0.01f;
    bool hasfloored = false;
    public GameObject particlesys;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        //11 times
            Vector3 spawn = gameObject.transform.position + gameObject.transform.up;
            Instantiate(particle, spawn, Random.rotation);
            Instantiate(particle, spawn, Random.rotation);
            Instantiate(particle, spawn, Random.rotation);
            Instantiate(particle, spawn, Random.rotation);
            Instantiate(particle, spawn, Random.rotation);
            Instantiate(particle, spawn, Random.rotation);
            Instantiate(particle, spawn, Random.rotation);
            Instantiate(particle, spawn, Random.rotation);
            Instantiate(particle, spawn, Random.rotation);
            Instantiate(particle, spawn, Random.rotation);
            Instantiate(particle, spawn, Random.rotation);

        
    }

    void OnCollisionEnter(Collision collision)
    {   if (collision.gameObject.layer == LayerMask.NameToLayer("ground"))
        {
            hasfloored = true;
            particlesys.SetActive(false);
            for (int i = 0; i <= 4; i++)
            {
                //gameObject.GetComponent<CapsuleCollider>().enabled = false;

                Vector3 spawn = gameObject.transform.position;
                Instantiate(particle, spawn, Random.rotation);
                Instantiate(particle, spawn, Random.rotation); 
                Instantiate(particle, spawn, Random.rotation); 
                Instantiate(particle, spawn, Random.rotation); 
                Instantiate(particle, spawn, Random.rotation); 
                Instantiate(particle, spawn, Random.rotation); 
                Instantiate(particle, spawn, Random.rotation); 
                Instantiate(particle, spawn, Random.rotation); 
                Instantiate(particle, spawn, Random.rotation); 
                Instantiate(particle, spawn, Random.rotation); 
                Instantiate(particle, spawn, Random.rotation); 
                Instantiate(particle, spawn, Random.rotation); 
                Instantiate(particle, spawn, Random.rotation); 
                Instantiate(particle, spawn, Random.rotation); 
                Instantiate(particle, spawn, Random.rotation); 
                Instantiate(particle, spawn, Random.rotation); 
                Instantiate(particle, spawn, Random.rotation); 
                Instantiate(particle, spawn, Random.rotation); 
                Instantiate(particle, spawn, Random.rotation); 
                Instantiate(particle, spawn, Random.rotation); 
                Instantiate(particle, spawn, Random.rotation); 
                Instantiate(particle, spawn, Random.rotation);

            }
        }
        //else { gameObject.GetComponent<CapsuleCollider>().enabled = false; }
       
    }

}

