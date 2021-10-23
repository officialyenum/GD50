using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class WinMessage : MonoBehaviour
{
    private Text text;
    public static string message = "";
    // Start is called before the first frame update
    void Start()
    {
        text = GetComponent<Text>();
    }

    // Update is called once per frame
    void Update()
    {
        text.text = message;
		// Debug.Log("Level text Line 21 Level :"+ LevelText.level);
    }
    // Start is called before the first frame update

}
