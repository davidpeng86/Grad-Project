using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class RigidbodyCharacter : MonoBehaviour
{
    public GameObject bullet;
    public GameObject clone;
    public int controllernumber;
    [SerializeField]
    float shootForce = 600f;
    [SerializeField]
    float atkRadius = 2f;
    [SerializeField]
    GameObject gunPoint;
    Animator anim;

    [SerializeField]
    private int shoot_CD = 1, sword_CD = 3 ,duplicate_CD = 5;
    private string horaxis;
    private string veraxis;
    private string shoot_attack, sword_attack, duplicate;

    private float shoot_count = 0, sword_count = 0, duplicate_count = 0;

    public float Speed = 5f;
    public float JumpHeight = 2f;

    private Rigidbody _body;
    private Vector3 _inputs = Vector3.zero;

    void Start()
    {
        _body = GetComponent<Rigidbody>();
        horaxis = "HorizontalP" + controllernumber;
        veraxis = "VerticalP" + controllernumber;
        shoot_attack = "Fire1P" + controllernumber;
        sword_attack = "Fire2P" + controllernumber;
        duplicate = "Fire3P" + controllernumber;

        anim = GetComponent<Animator>();

    }

    void Update()
    {
        _inputs = Vector3.zero;
        _inputs.x = Input.GetAxis(horaxis);
        _inputs.z = Input.GetAxis(veraxis);
        if (_inputs != Vector3.zero)
            transform.forward = _inputs;

        if(shoot_count >= 0)
            shoot_count -= (float)1/60;
        if(sword_count >= 0)
            sword_count -= (float)1/60;
        if(duplicate_count >= 0)
            duplicate_count -= (float)1/60;

        if (Input.GetButtonDown(shoot_attack) && gunPoint != null && shoot_count <= 0) {
            GameObject temp_bullet =
                Instantiate(bullet, gunPoint.transform.position, gunPoint.transform.rotation);
            temp_bullet.tag = this.tag;
            temp_bullet.transform.Rotate(Vector3.left * 90f, Space.Self);

            Rigidbody temp_rigidbody = temp_bullet.GetComponent<Rigidbody>();
            temp_rigidbody.AddRelativeForce(Vector3.down * shootForce);
            shoot_count = shoot_CD;
            Destroy(temp_bullet,2.5f);
        }

        if(Input.GetButtonDown(sword_attack) && sword_count <= 0){
            Collider[] colliders = Physics.OverlapSphere(transform.position, atkRadius);
            if(colliders.Length <= 0) return;
            anim.SetBool("enemy",false);
            anim.SetTrigger("attack");
            sword_count = sword_CD;

            colliders = Physics.OverlapSphere(transform.position, atkRadius);
            for (int i = 0; i < colliders.Length; i++){
                if (colliders[i].transform.root != transform){
                    if(colliders[i].gameObject.layer == LayerMask.NameToLayer("player"))
                    {
                        anim.SetBool("enemy",true);
                        PlayerState ps = colliders[i].GetComponent<PlayerState>();
                        ps.currentHp -= 3;
                        ps.TakeDamage();
                    }
                    print(colliders[i].gameObject.name);
                }
            }
        }

        if(Input.GetButtonDown(duplicate) && duplicate_count <= 0){
            //make prefab
            duplicate_count = duplicate_CD;
            GameObject fake = Instantiate(clone, transform.position+ transform.forward*2,transform.rotation);
            //fake.GetComponent<Rigidbody>().AddRelativeForce(fake.transform.forward * Speed * 2, ForceMode.Impulse);
            Destroy(fake,1);
        }
    }

    [Range(0f,1f)]
    public float x,y;
    int w = 40,h = 20;
    private void OnGUI() {
        GUI.Box(new Rect((x - 0.03f) * Screen.width, y * Screen.height, w, h), shoot_count.ToString("0.0"));
        GUI.Box(new Rect(x * Screen.width, y * Screen.height, w, h), sword_count.ToString("0.0"));
        GUI.Box(new Rect((x + 0.03f) * Screen.width, y * Screen.height, w, h), duplicate_count.ToString("0.0"));
    }



    Vector3 newPosition = Vector3.zero;
    void FixedUpdate()
    {
        if (_inputs != Vector3.zero){
            newPosition = new Vector3(_inputs.x, 0.0f, _inputs.z);
            //transform.DOLookAt(newPosition*4 + transform.position, 0.3f);
        }
        transform.LookAt(newPosition + transform.position);

        _body.MovePosition(_body.position + _inputs * Speed * Time.fixedDeltaTime);
    }

}