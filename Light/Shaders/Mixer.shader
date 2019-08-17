// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Lighting/Mixer"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		// No culling or depth
		//Cull Off ZWrite Off ZTest Always

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
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			sampler2D _LightTex;
			sampler2D _AmbientLightTex;
			float _Scale;

			fixed4 frag (v2f i) : SV_Target
			{
				//float2 fixedUV = float2 (i.uv.x, i.uv.y);
				float2 scaledUV = float2(0.5f - 0.5f / _Scale + i.uv.x / _Scale, 0.5f - 0.5f / _Scale + i.uv.y / _Scale);
				#if UNITY_UV_STARTS_AT_TOP
				scaledUV.y = scaledUV.y;
				#endif
				fixed4 col = tex2D(_MainTex, i.uv) * max(tex2D(_LightTex, scaledUV), tex2D(_AmbientLightTex, scaledUV));
				//if (scaledUV.x > 0.5f) return float4(1, 0, 0, 0);
				return col;
			}
			ENDCG
		}
	}
}
