using UnityEngine;
using System.Collections;

[RequireComponent (typeof (Camera))]
public class LightSystem : MonoBehaviour {

    Camera mainCamera;
    Camera lightSourceCamera;
    Camera lightObstacleCamera;
    Camera lightAmbientCamera;
    Camera lightAmbientObstacleCamera;

    public LayerMask lightSourceMask;
    public LayerMask lightObstacleMask;
    public LayerMask lightAmbientObstacleMask;
    public LayerMask lightAmbientMask;

    public int RTHeight = 88;
    public int lightCameraOverlap = 1;
    RenderTexture lightSourceRT;
    RenderTexture lightObstacleRT;
    RenderTexture lightAmbientRT;
    RenderTexture lightAmbientObstacleRT;

    public Color ambientColor = Color.white;

    // Use this for initialization
    void Awake () {
        mainCamera = GetComponent<Camera> ();

        lightSourceRT = CreateRT (/*Mathf.CeilToInt*/(int) (mainCamera.aspect * RTHeight), RTHeight);
        lightSourceCamera = CreateCamera (Color.black, lightSourceMask, mainCamera.aspect, mainCamera.orthographicSize * lightCameraOverlap, lightSourceRT);
        lightSourceCamera.gameObject.name = "Light Source Camera";

        lightObstacleRT = CreateRT (/*Mathf.CeilToInt*/(int) (mainCamera.aspect * RTHeight), RTHeight);
        lightObstacleCamera = CreateCamera (Color.black, lightObstacleMask, mainCamera.aspect, mainCamera.orthographicSize * lightCameraOverlap, lightObstacleRT);
        lightObstacleCamera.gameObject.name = "Light Obstacle Camera";

        lightAmbientRT = CreateRT (/*Mathf.CeilToInt*/(int) (mainCamera.aspect * RTHeight), RTHeight);
        //iterativeRT = CreateRT (Mathf.CeilToInt (mainCamera.aspect * RTHeight), RTHeight);
        lightAmbientCamera = CreateCamera (ambientColor, lightAmbientMask, mainCamera.aspect, mainCamera.orthographicSize * lightCameraOverlap, lightAmbientRT);
        lightAmbientCamera.gameObject.name = "Light Ambient Camera";

        lightAmbientObstacleRT = CreateRT (/*Mathf.CeilToInt*/(int) (mainCamera.aspect * RTHeight), RTHeight);
        lightAmbientObstacleCamera = CreateCamera (Color.black, lightAmbientObstacleMask, mainCamera.aspect, mainCamera.orthographicSize * lightCameraOverlap, lightAmbientObstacleRT);
        lightAmbientObstacleCamera.gameObject.name = "Light Ambient Obstacle Camera";

        lightSourceCamera.enabled = false; // OMFG SOMEHOW IT FIXES GLITCHES
        lightSourceCamera.enabled = true;

        lightAmbientCamera.gameObject.AddComponent<AmbientLight> ();
        gameObject.AddComponent<Mixer> ();
    }

    void Update () { // move ambient color and ambient cameras to AmbientLight.cs
        lightAmbientCamera.backgroundColor = ambientColor;
    }

    RenderTexture CreateRT (int RTWidth, int RTHeight) {
        // RT
        RenderTexture rt = new RenderTexture (RTWidth, RTHeight, 24);
        rt.Create ();
        return rt;
    }

    Camera CreateCamera (Color backgroundColor, LayerMask cullingMask, float aspect, float ortographicSize, RenderTexture rt) {
        // GameObject
        GameObject cameraObject = new GameObject ();
        cameraObject.transform.SetParent (transform);
        cameraObject.transform.localPosition = Vector3.zero;

        // Camera
        Camera camera = cameraObject.AddComponent<Camera> ();
        camera.backgroundColor = backgroundColor;
        camera.clearFlags = CameraClearFlags.SolidColor;
        camera.cullingMask = cullingMask;
        camera.aspect = aspect;
        camera.orthographic = true;
        camera.orthographicSize = ortographicSize;
        camera.targetTexture = rt;

        return camera;
    }

    public RenderTexture GetLightSourceRT () {
        return lightSourceRT;
    }
    public RenderTexture GetLightObstacleRT () {
        return lightObstacleRT;
    }
    public RenderTexture GetAmbientRT () {
        return lightAmbientRT;
    }
    public RenderTexture GetLightAmbientObstacleRT () {
        return lightAmbientObstacleRT;
    }
}
