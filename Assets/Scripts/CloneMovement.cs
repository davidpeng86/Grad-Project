﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CloneMovement : MonoBehaviour
{
    Rigidbody body;
    // Start is called before the first frame update
    void Start()
    {
        body = GetComponent<Rigidbody>();   
    }

    // Update is called once per frame
    void Update()
    {
        
    }
     void FixedUpdate()
    {
        body.velocity = transform.forward * 5f ;
    }
}
