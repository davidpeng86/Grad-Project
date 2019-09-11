using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OptionalInvisibilityController : MonoBehaviour
{
    public int controllernumber;
    [SerializeField]
    float atkRadius = 2f;
    Animator anim;

    [SerializeField]
    private int sword_CD = 3;
    private string horaxis, veraxis, sword_attack, invisible;

    private float sword_count = 0;

    public float Speed = 5f;
    public float JumpHeight = 2f;
    public float GroundDistance = 0.2f;
    public LayerMask Ground;

    private Rigidbody _body;
    private MeshRenderer _meshRenderer;
    private Vector3 _inputs = Vector3.zero;

    void Start()
    {
        _body = GetComponent<Rigidbody>();
        _meshRenderer = GetComponent<MeshRenderer>();
        horaxis = "HorizontalP" + controllernumber;
        veraxis = "VerticalP" + controllernumber;
        sword_attack = "Fire1P" + controllernumber;

        anim = GetComponent<Animator>();

    }
    
    void Update() {
        _inputs = Vector3.zero;
        _inputs.x = Input.GetAxis(horaxis);
        _inputs.z = Input.GetAxis(veraxis);
        if (_inputs != Vector3.zero)
            transform.forward = _inputs;

        if (sword_count >= 0)
            sword_count -= (float)1 / 60;

        if (Input.GetButtonDown(sword_attack) && sword_count <= 0)
        {

            Collider[] colliders = Physics.OverlapSphere(transform.position, atkRadius);
            if (colliders.Length <= 0) return;
            anim.SetBool("enemy", false);
            anim.SetTrigger("attack");
            sword_count = sword_CD;

            colliders = Physics.OverlapSphere(transform.position, atkRadius);
            for (int i = 0; i < colliders.Length; i++)
            {
                if (colliders[i].transform.root != transform)
                {
                    if (colliders[i].gameObject.layer == LayerMask.NameToLayer("player"))
                    {
                        var heading = colliders[i].transform.position - transform.position;
                        var direction = heading / heading.magnitude;
                        colliders[i].gameObject.GetComponent<Rigidbody>().AddForce(direction * 10f, ForceMode.Impulse);
                        anim.SetBool("enemy", true);
                        PlayerState ps = colliders[i].GetComponent<PlayerState>();
                        ps.currentHp -= 3;
                        ps.TakeDamage();
                    }
                    print(colliders[i].gameObject.name);
                }
            }
        }
    }

    [Range(0f, 1f)]
    public float x, y;
    int w = 40, h = 20;
    private void OnGUI()
    {
        GUI.Box(new Rect(x * Screen.width, y * Screen.height, w, h), sword_count.ToString("0.0"));
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
