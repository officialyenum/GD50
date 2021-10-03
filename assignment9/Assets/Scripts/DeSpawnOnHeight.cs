using System.Collections;
using System.Collections.Generic;
using UnityEngine.SceneManagement;
using UnityEngine;

public class DeSpawnOnHeight : MonoBehaviour
{
    public static Vector3 player;
    private AudioSource gameOverAudioSource;

    // Start is called before the first frame update
	void Start()
	{
		gameOverAudioSource = DontDestroy.instance.GetComponents<AudioSource>()[0];
	}

    // Update is called once per frame
    void Update()
    {
        // constrain movement within the bounds of the camera
			// if (player.transform.position.y < -15.0f) {
            //     // restore universal level text to 0
            //     LevelText.level = 0;
            //     DontDestroy.instance = null;
            //     SceneManager.LoadScene("GameOver");
			// }
        // Get Player using Tag
        player = GameObject.FindWithTag("Player").transform.position;
        // Get Player using Camera position
        // player = Camera.main.gameObject.transform.position;
		if (player.y < -10)
		{ 
            //remove audio
			Destroy(gameOverAudioSource);
            //reset level to 0
			LevelText.level = 1;
            // set destroy instance
			DontDestroy.instance = null;
            // load gameover scene
			SceneManager.LoadScene("GameOver");
		}
    }
}
