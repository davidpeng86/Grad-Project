﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerState : MonoBehaviour
{
    public Material dmg_mat;
    Material origin_mat;
    public int hpMax = 5;
    public int currentHp;
    public bool isDead, isShown = false, win;
    public MeshRenderer mr_head;
    public SkinnedMeshRenderer mr_cloak;
    Transform blur;
    float timer = 0;
    // Start is called before the first frame update
    void Start()
    {
        origin_mat = mr_head.material;
        currentHp = hpMax;
        isDead = false;
        win = false;
        blur = transform.Find("Swirl_Distortion");
    }

    // Update is called once per frame
    void Update()
    {
        if(isShown){
            timer+= Time.deltaTime;
            blur.gameObject.SetActive(true);
            if (timer > 3)
            {
                isShown = false;
                blur.gameObject.SetActive(false);
                timer = 0;
            }
        }
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
        if(!win)
            StartCoroutine(flash());
    }

    IEnumerator flash() {
        if(mr_cloak != null){
            mr_head.material = dmg_mat;
            mr_cloak.material = dmg_mat;
            for(int i = 0; i<3; i++) {
                mr_head.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.On;
                mr_cloak.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.On;
                yield return new WaitForSeconds(0.05f);
                mr_head.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.ShadowsOnly;
                mr_cloak.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.ShadowsOnly;
                yield return new WaitForSeconds(0.05f);
            }
            mr_head.material = origin_mat;
            mr_cloak.material = origin_mat;
        }
        yield return new WaitForSeconds(0.05f);
        if (currentHp <= 0 && !win)
        {
            isDead = true;
            Destroy(gameObject);
        }
    }
}
