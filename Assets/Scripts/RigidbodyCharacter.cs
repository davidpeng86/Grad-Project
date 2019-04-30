using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RigidbodyCharacter : MonoBehaviour
{

    public float Speed = 5f;
    public float JumpHeight = 2f;
    public float GroundDistance = 0.2f;
    public LayerMask Ground;

    private Rigidbody _body;
    private Vector3 _inputs = Vector3.zero;

    void Start()
    {
        _body = GetComponent<Rigidbody>();
    }

    void Update()
    {
        _inputs = Vector3.zero;
        _inputs.x = Input.GetAxis("HorizontalP1");
        _inputs.z = Input.GetAxis("VerticalP1");
        if (_inputs != Vector3.zero)
            transform.forward = _inputs;
    }

    Vector3 newPosition = Vector3.zero;
    void FixedUpdate()
    {
        if (_inputs != Vector3.zero)
            newPosition = new Vector3(_inputs.x, 0.0f, _inputs.z);

        transform.LookAt(newPosition + transform.position);

        _body.MovePosition(_body.position + _inputs * Speed * Time.fixedDeltaTime);
    }
}