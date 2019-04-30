using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class JoyStickController : MonoBehaviour
{
    public Rigidbody rb;
    private int controllernumber;
    private string horaxis;
    private string veraxis;
    private string Rbutton;
    private string Dbutton;

    public int playernumber;
    // Use this for initialization
	void Start () {
		
	}
    
    void SetContollerNumber(int number)
    {
        controllernumber = number;
        horaxis = "HorizontalP" + controllernumber;
        veraxis = "VerticalP" + controllernumber;
        Rbutton = "Fire1P" + controllernumber;
    }

    void addcontroller() {
        
    }
	// Update is called once per frame
	void Update () {
        if (Input.GetButton("Fire1P"+playernumber))
        {
            rb.AddForce(0, 200, 0);
        }
        if (Input.GetAxis("HorizontalP"+playernumber) >0)
        {
            rb.AddForce(100, 0, 0);
        }
        if (Input.GetAxis("HorizontalP"+playernumber) < 0)
        {
            rb.AddForce(-100, 0, 0);
        }
        if (Input.GetAxis("VerticalP"+playernumber) > 0)
        {
            rb.AddForce(0, 0, 100);
        }
        if (Input.GetAxis("VerticalP" + playernumber) < 0)
        {
            rb.AddForce(0, 0, -100);
        }
    }
}
