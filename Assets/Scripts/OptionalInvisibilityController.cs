using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OptionalInvisibilityController : MonoBehaviour
{
    public GameObject bullet;
    public int controllernumber;
    [SerializeField]
    float shootForce = 600f;
    [SerializeField]
    float atkRadius = 2f;
    [SerializeField]
    GameObject gunPoint;
    Animator anim;

    [SerializeField]
    private int shoot_CD = 1, sword_CD = 3, invisible_CD = 2, invisible_duration = 5 ;
    private string horaxis;
    private string veraxis;
    private string shoot_attack;
    private string sword_attack;
    private string invisible;

    private float shoot_count = 0, sword_count = 0, invisible_count = 0, invis_duration = 0;

    public bool isVisible = true;
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
        shoot_attack = "Fire1P" + controllernumber;
        sword_attack = "Fire2P" + controllernumber;
        invisible = "Fire3P" + controllernumber;

        anim = GetComponent<Animator>();

    }
    
    void Update() {
        _inputs = Vector3.zero;
        _inputs.x = Input.GetAxis(horaxis);
        _inputs.z = Input.GetAxis(veraxis);
        if (_inputs != Vector3.zero)
            transform.forward = _inputs;

        if (shoot_count >= 0)
            shoot_count -= (float)1 / 60;
        if (sword_count >= 0)
            sword_count -= (float)1 / 60;
        if(invisible_count >= 0)
            invisible_count -= (float)1 / 60;
        if(invis_duration >= 0)
            invis_duration -= (float)1 / 60;

        print(shoot_count);
        print(sword_count);

        if (Input.GetButtonDown(invisible) && invisible_count <= 0)
        {
            isVisible = false;
            invis_duration = invisible_duration;
            //isVisible = !isVisible;
        }
        if (isVisible == true )
        {
            _meshRenderer.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.On;
        }
        else
        {
            _meshRenderer.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.ShadowsOnly;
            if (invis_duration<=0) {
                invisible_count = invisible_CD;
                isVisible = true;
            }
        }

        if (Input.GetButtonDown(shoot_attack) && gunPoint != null && shoot_count <= 0)
        {
            GameObject temp_bullet =
                Instantiate(bullet, gunPoint.transform.position, gunPoint.transform.rotation);
            temp_bullet.tag = this.tag;
            temp_bullet.transform.Rotate(Vector3.left * 90f, Space.Self);

            Rigidbody temp_rigidbody = temp_bullet.GetComponent<Rigidbody>();
            temp_rigidbody.AddRelativeForce(Vector3.down * shootForce);
            shoot_count = shoot_CD;
            Destroy(temp_bullet, 2);
        }

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
        GUI.Box(new Rect((x - 0.03f) * Screen.width, y * Screen.height, w, h), shoot_count.ToString("0.0"));
        GUI.Box(new Rect(x * Screen.width, y * Screen.height, w, h), sword_count.ToString("0.0"));

        GUI.Box(new Rect((x+0.03f) * Screen.width, y * Screen.height, w, h), invisible_count.ToString("0.0"));
        GUI.Box(new Rect((x+0.06f) * Screen.width, y * Screen.height, w, h), invis_duration.ToString("0.0"));
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
