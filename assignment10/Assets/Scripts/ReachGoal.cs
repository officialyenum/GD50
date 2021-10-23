using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class ReachGoal : MonoBehaviour
{
    void OnControllerColliderHit(ControllerColliderHit hit) {
		if (hit.gameObject.tag == "Money") {
			Destroy(hit.gameObject);
            WinMessage.message = "You Win !!!";
            
            SceneManager.LoadScene("Level");
        }

        if (hit.gameObject.tag == "Terrain") {
            WinMessage.message = "Try Again, You Fell !!!";

            SceneManager.LoadScene("Level");
        }

        if (hit.gameObject.tag == "Start") {
            WinMessage.message = "";
        }
	}
}
