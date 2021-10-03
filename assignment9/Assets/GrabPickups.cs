using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GrabPickups : MonoBehaviour {

	private AudioSource pickupSoundSource;

	void Awake() {
		pickupSoundSource = GetComponents<AudioSource>()[1];
	}

	void OnControllerColliderHit(ControllerColliderHit hit) {
		if (hit.gameObject.tag == "Pickup") {
			Destroy(hit.gameObject);
			pickupSoundSource.Play();
			// increase level by 1 
			Debug.Log("Grab Pickup Line 18 Level :"+ LevelText.level);
			LevelText.level += 1;
			// LevelText.addOne();
            SceneManager.LoadScene("Play");
		}
	}
}
