using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class particlefade : MonoBehaviour
{
    // Update is called once per frame
    void Update()
    {
        float faderand = Random.Range(0.6f, 1);
        gameObject.transform.localScale -= new Vector3(0.05f, 0.05f, 0.05f)*Time.deltaTime * faderand*0.8f;
        if (gameObject.transform.localScale.x <= 0)
        { Destroy(gameObject); }
    }
}
