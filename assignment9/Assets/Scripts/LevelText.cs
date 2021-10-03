using System.Collections;
using System.Collections.Generic;
using UnityEngine.SceneManagement;
using UnityEngine;
using UnityEngine.UI;

public class LevelText : MonoBehaviour
{
    private Text text;
    public static int level = 1;
    // Start is called before the first frame update
    void Start()
    {
        text = GetComponent<Text>();
    }

    // Update is called once per frame
    void Update()
    {
        text.text = "Level: " + level;
		// Debug.Log("Level text Line 21 Level :"+ LevelText.level);
    }
}
