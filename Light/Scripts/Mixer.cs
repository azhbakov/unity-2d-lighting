using UnityEngine;
using System.Collections;

public class Mixer : MonoBehaviour {

    LightSystem lightSystem;
    Material blitMaterial;

    // Use this for initialization
    void Start () {
        lightSystem = FindObjectOfType<LightSystem> ();
        if (lightSystem == null) {
            throw new UnityException ("Scene missing light system gameobject");
        }

        blitMaterial = new Material (Shader.Find ("Lighting/Mixer"));
        blitMaterial.SetTexture ("_LightTex", lightSystem.GetLightSourceRT ());
        blitMaterial.SetTexture ("_AmbientLightTex", lightSystem.GetAmbientRT ());
        blitMaterial.SetFloat ("_Scale", lightSystem.lightCameraOverlap);
    }
	
	void OnRenderImage (RenderTexture src, RenderTexture dest) {
        //Graphics.Blit (lightSystem.GetAmbientRT (), dest);
        Graphics.Blit (src, dest, blitMaterial);
    }
}
