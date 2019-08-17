// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Lighting/AmbientLight"
{
	Properties
	{
	
		_MainTex ("Texture", 2D) = "white" {}
		_SamplingDist ("Sampling Distance", Float) = 0.02
	}
	SubShader
	{
		    ZTest Always Cull Off ZWrite Off
    Fog { Mode off }


		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex; // iterative
			sampler2D _ObstacleTex;
			float4 _AmbientColor;
			float _ObstacleMul;
			half _SamplingDist;

			fixed4 frag (v2f i) : SV_Target
			{
				half4 obstacle = tex2D(_ObstacleTex, i.uv);
				obstacle = saturate(1 - obstacle*_ObstacleMul);

				half4 oldLight = tex2D(_MainTex, i.uv);

				// computing average value of near pixels
				half4 maxLight = tex2D(_MainTex, i.uv + half2(_SamplingDist, 0));
				maxLight = max(maxLight, tex2D(_MainTex, i.uv + half2(-_SamplingDist, 0)));
				maxLight = max(maxLight, tex2D(_MainTex, i.uv + half2(0, -_SamplingDist)));
				maxLight = max(maxLight, tex2D(_MainTex, i.uv + half2(0, _SamplingDist)));
				half dist45 = _SamplingDist*0.707;
				maxLight = max(maxLight, tex2D(_MainTex, i.uv + half2(dist45, dist45)));
				maxLight = max(maxLight, tex2D(_MainTex, i.uv + half2(dist45, -dist45)));
				maxLight = max(maxLight, tex2D(_MainTex, i.uv + half2(-dist45, dist45)));
				maxLight = max(maxLight, tex2D(_MainTex, i.uv + half2(-dist45, -dist45)));

				half4 col = maxLight * obstacle;
				//if (i.uv.x > 0.5f) return float4(1,0,0,0);
				//return oldLight;
				//return float4(1,0,0,0);
				return lerp(oldLight, col, 1);
			}
			ENDCG
		}
	}
}
