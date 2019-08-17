using UnityEngine;
using System.Collections;

public class LightObstacle : MonoBehaviour {

    //LightSystem lightSystem;
    new SpriteRenderer renderer;
    SpriteRenderer obstacleRenderer;

    public Color subtractLight;
    public LayerMask obstacleMask;
    public bool useCustom = false;
    public Material obstacleMaterial;

    // Use this for initialization
    void Start () {
        /*lightSystem = FindObjectOfType<LightSystem> ();
        if (lightSystem == null) {
            throw new UnityException ("Scene missing light system gameobject");
        }*/

        renderer = GetComponent<SpriteRenderer> ();
        if (renderer == null) {
            throw new UnityException ("Missing Renderer component in light source");
        }

        GameObject obstacleObject = new GameObject ();
        obstacleObject.transform.SetParent (transform);
        obstacleObject.transform.localPosition = Vector3.zero;
        obstacleObject.transform.localScale = Vector3.one;
        obstacleObject.name = "Light Obstacle";
        obstacleObject.layer = (int) Mathf.Log (obstacleMask.value, 2);

        obstacleRenderer = obstacleObject.AddComponent<SpriteRenderer> ();
        if (useCustom || obstacleMaterial == null) {
            useCustom = true;
            obstacleRenderer.material = new Material (Shader.Find ("Unlit/Color"));
            obstacleRenderer.material.SetColor ("_Color", subtractLight);
        } else {
            obstacleRenderer.material = obstacleMaterial;
        }
        obstacleRenderer.sprite = renderer.sprite;
        obstacleRenderer.sortingOrder = renderer.sortingOrder;
    }
	
	// Update is called once per frame
	void Update () {
        if (useCustom || obstacleMaterial == null) {
            useCustom = true;
            obstacleRenderer.material.SetColor ("_Color", subtractLight);
        }
        obstacleRenderer.sprite = renderer.sprite;
        obstacleRenderer.sortingOrder = renderer.sortingOrder;
    }
}
