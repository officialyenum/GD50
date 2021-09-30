using System.Collections;
using System.Collections.Generic;
using UnityEngine.SceneManagement;
using UnityEngine;

public class DeSpawnOnHeight : MonoBehaviour
{
    public static Vector3 player;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        // constrain movement within the bounds of the camera
			if (transform.position.y < -15.0f) {
                // restore universal level text to 1
                LevelText.level = 1;
                DontDestroy.instance = null;
                SceneManager.LoadScene("GameOver");
			}
    }
}
