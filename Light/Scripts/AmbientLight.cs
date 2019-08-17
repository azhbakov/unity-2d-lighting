using UnityEngine;
using System.Collections;

public class AmbientLight : MonoBehaviour {

    LightSystem lightSystem;
    public int iterations = 50;
    //public Color ambientColor = Color.white;
    public float obstacleMul = 0.25f;
    public float samplingDist = 0.005f;
    Material ambientLightMaterial;

    RenderTexture lightAmbientRT;
    RenderTexture lightAmbientObstacleRT;
    //RenderTexture iterativeRT1;
    //RenderTexture iterativeRT2;

    // Use this for initialization
    void Awake () {
        lightSystem = FindObjectOfType<LightSystem> ();
        if (lightSystem == null) {
            throw new UnityException ("Scene missing LightSystem");
        }

        if (!GetComponent<Camera> ()) {
            throw new UnityException ("Ambient Light Script should be attached to ambient obstacle camera");
        }

        lightAmbientRT = lightSystem.GetAmbientRT ();
        lightAmbientObstacleRT = lightSystem.GetLightAmbientObstacleRT ();
        /*iterativeRT1 = new RenderTexture (lightAmbientRT.width, lightAmbientRT.height, lightAmbientRT.depth);
        iterativeRT1.Create ();
        iterativeRT2 = new RenderTexture (lightAmbientRT.width, lightAmbientRT.height, lightAmbientRT.depth);
        iterativeRT2.Create ();*/

        ambientLightMaterial = new Material (Shader.Find ("Lighting/AmbientLight"));
        ambientLightMaterial.SetTexture ("_ObstacleTex", lightAmbientObstacleRT);
        //ambientLightMaterial.SetColor ("_AmbientColor", ambientColor);
        ambientLightMaterial.SetFloat ("_ObstacleMul", obstacleMul);
        ambientLightMaterial.SetFloat ("_SamplingDist", samplingDist);
    }

    void OnRenderImage (RenderTexture src, RenderTexture dest) {
        //ambientLightMaterial.SetColor ("_AmbientColor", ambientColor);
        ambientLightMaterial.SetFloat ("_ObstacleMul", obstacleMul);
        ambientLightMaterial.SetFloat ("_SamplingDist", samplingDist);
        //if (iterativeRT1.IsCreated () == false) print ("azaza");
        RenderTexture iterativeRT1 = RenderTexture.GetTemporary (lightAmbientRT.width, lightAmbientRT.height, lightAmbientRT.depth);
        RenderTexture iterativeRT2 = RenderTexture.GetTemporary (lightAmbientRT.width, lightAmbientRT.height, lightAmbientRT.depth);
        Graphics.Blit (src, iterativeRT1, ambientLightMaterial);
        //Graphics.Blit (iterativeRT1, dest, ambientLightMaterial);
        for (int i = 0; i < iterations; i++) {
            Graphics.Blit (iterativeRT1, iterativeRT2, ambientLightMaterial);
            Graphics.Blit (iterativeRT2, iterativeRT1, ambientLightMaterial);
        }
        Graphics.Blit (iterativeRT1, dest, ambientLightMaterial);
        RenderTexture.ReleaseTemporary(iterativeRT1);
        RenderTexture.ReleaseTemporary(iterativeRT2);
    }
}
