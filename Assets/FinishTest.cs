using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FinishTest : MonoBehaviour
{
    public bool isFinish;
    public float counter;
    public float counter1;
    public GameObject player;
    void Start()
    {
        counter1 = -0.5f;
        counter = transform.position.z - transform.localScale.z/2 ;
        player=GameObject.FindWithTag("Player");
    }

    void Update()
    {
        Debug.Log(counter);
        player.transform.Translate(Vector3.forward*Time.deltaTime*3);
        if (isFinish)
        {
            //Changes saturation every time when object is entering each square
            if (player.transform.position.z > counter)
            {
                //its changing saturation between -0.5 0.5
                counter1 += 1/this.gameObject.GetComponent<MeshRenderer>().material.GetFloat("_LineCount");
                this.gameObject.GetComponent<MeshRenderer>().material.SetFloat("_Value",counter1);
                //checking position
                counter += transform.localScale.z/this.gameObject.GetComponent<MeshRenderer>().material.GetFloat("_LineCount");
            }
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if(other.gameObject.tag=="Player")
        isFinish = true;
        
    }
}
