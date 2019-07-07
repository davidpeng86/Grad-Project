using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerState : MonoBehaviour
{
    public Material dmg_mat;
    Material origin_mat;
    public int hpMax = 5;
    public int currentHp;
    public bool isDead;
    public bool win;
    MeshRenderer mr;

    // Start is called before the first frame update
    void Start()
    {
        mr = GetComponent<MeshRenderer>();
        origin_mat = mr.material;
        currentHp = hpMax;
        isDead = false;
        win = false;
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    [Range(0f,1f)]
    public float x,y;
    public int w;
    public int h;

    private void OnGUI()
    {
        string state = "";
        for (int i = 0; i < currentHp; i++) {
            if (currentHp < 1) {
                state = "dead";
                break;
            }
            state += "Ｏ ";
        }
        GUI.Box(new Rect(x * Screen.width, y * Screen.height, w, h), state);
    }

    public void TakeDamage() {
        StartCoroutine(flash());
    }

    IEnumerator flash() {
        mr.material = dmg_mat;
        for(int i = 0; i<3; i++) {
            mr.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.On;
            yield return new WaitForSeconds(0.05f);
            mr.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.ShadowsOnly;
            yield return new WaitForSeconds(0.05f);
        }
        mr.material = origin_mat;
        yield return new WaitForSeconds(0.05f);
        if (currentHp <= 0)
        {
            isDead = true;
            Destroy(gameObject);
        }
    }
}
