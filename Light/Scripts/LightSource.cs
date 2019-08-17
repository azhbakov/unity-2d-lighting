using UnityEngine;
using System.Collections;

public class LightSource : MonoBehaviour {

    LightSystem lightSystem;
    new Renderer renderer;

    public float obstacleMul = 20;
    public Color colorTint = Color.white;
    public Transform centerGizmo;

    Vector3 centerPos;

	// Use this for initialization
	void Start () {
        lightSystem = FindObjectOfType<LightSystem> ();
        if (lightSystem == null) {
            throw new UnityException ("Scene missing light system gameobject");
        }

        renderer = GetComponent<Renderer> ();
        if (renderer == null) {
            throw new UnityException ("Missing Renderer component in light source");
        }

	    if (centerGizmo) {
            centerPos = centerGizmo.position;
        } else {
            centerPos = transform.position;
        }

        Material material = new Material (Shader.Find("Lighting/LightSource"));
        material.mainTexture = renderer.material.mainTexture;
        material.SetTexture ("_ObstacleTex", lightSystem.GetLightObstacleRT ());
        material.SetFloat ("_ObstacleMul", obstacleMul);
        material.SetVector ("_centerPos", new Vector4 (centerPos.x, centerPos.y, 1, 1));
        material.SetColor ("_ColorTint", colorTint);

        renderer.material = material;
	}
	
	// Update is called once per frame
	void Update () {
        if (centerGizmo) {
            centerPos = centerGizmo.position;
        } else {
            centerPos = transform.position;
        }
        renderer.material.SetFloat ("_ObstacleMul", obstacleMul);
        renderer.material.SetVector ("_centerPos", new Vector4 (centerPos.x, centerPos.y, 1, 1));
        renderer.material.SetColor ("_ColorTint", colorTint);
    }
}
