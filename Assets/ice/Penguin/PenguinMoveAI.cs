using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PenguinMoveAI : MonoBehaviour
{
    
    public float PenguinSpeed = 0.2f;
    public float PenguinRotation = 30.0f;

    private bool PenguinState = false;
    private bool PenguinState_Walk = false;
    private bool PenguinState_Rotation = false;


    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (PenguinState == false)
        {
            StartCoroutine(Wander());
            //transform.Translate(Vector3.forward * Time.deltaTime);
        }
        if (PenguinState_Rotation == true)
        {
            transform.Rotate(Vector3.up * Time.deltaTime * PenguinRotation);
            Debug.Log("R");
        }
        if (PenguinState_Walk == true)
        {
            transform.position += transform.forward * PenguinSpeed * Time.deltaTime;
        }
    }

    IEnumerator Wander()
    {
        int rotTime = UnityEngine.Random.Range(0, 1);
        int rotationWait = UnityEngine.Random.Range(0, 1);
        int rotationLor = 1;
        int WalkWait = UnityEngine.Random.Range(1, 3);
        int WalkTime = UnityEngine.Random.Range(1, 5);

        PenguinState = true;

        yield return new WaitForSeconds(WalkWait);
        PenguinState_Walk = true;
        PenguinState_Rotation = false;
        yield return new WaitForSeconds(WalkTime);
        PenguinState_Walk = false;
        PenguinState_Rotation = false;
        yield return new WaitForSeconds(rotationLor);
        if (rotationLor == 1)
        {
            PenguinState_Walk = false;
            yield return new WaitForSeconds(rotTime);
            PenguinState_Rotation = true;
        }
        PenguinState = false;

    }
}
