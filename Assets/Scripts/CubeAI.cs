using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CubeAI : MonoBehaviour
{
    Vector3 _inputs = new Vector3(0,0,0);
    // Start is called before the first frame update
    void Start()
    {
        Tick();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void FixedUpdate()
    {
        if (_inputs != Vector3.zero)
            this.transform.Translate(_inputs * Time.fixedDeltaTime);
    }

    IEnumerator Tick() {
        while (true)
        {
            yield return new WaitForSeconds(Random.Range(1, 2));
            _inputs = new Vector3(Random.Range(-1, 1), 0, Random.Range(-1, 1));
        }
    }
}
