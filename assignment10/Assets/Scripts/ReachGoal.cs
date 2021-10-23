using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class ReachGoal : MonoBehaviour
{
    void OnControllerColliderHit(ControllerColliderHit hit) {
		if (hit.gameObject.tag == "Money") {
			Destroy(hit.gameObject);
            WinMessage.message = "Congratulations You Won !!!";
            
            SceneManager.LoadScene("Level");
        }

        if (hit.gameObject.tag == "Terrain") {
            WinMessage.message = "Game Over !!!";

            SceneManager.LoadScene("Level");
        }

        if (hit.gameObject.tag == "Start") {
            WinMessage.message = "";
        }
	}
}
