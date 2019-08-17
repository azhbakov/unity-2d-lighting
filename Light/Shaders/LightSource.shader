// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Lighting/LightSource"
{
	Properties
	{
		[HideInInspector]
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		// No culling or depth
		Cull Off 
		//ZWrite Off 
		//ZTest Always
		BlendOp Max
		Blend One One

		Pass
		{
			CGPROGRAM
//#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			sampler2D _ObstacleTex;
			float _ObstacleMul;
			float2 _centerPos;
			float4 _ColorTint;

//#define ITERATIONS 40
//#pragma glsl_no_auto_normalization

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				float2 scrPos : TEXCOORD1; // in screen space
				float2 centerScrPos : TEXCOORD2; // in screen space
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;

				float4 pos = ComputeScreenPos (o.vertex);
				o.scrPos = pos.xy / pos.w; // for what?..

				pos = ComputeScreenPos(mul(UNITY_MATRIX_VP, float4(_centerPos, 0, 1)));
				o.centerScrPos = pos.xy / pos.w; // for what?..

				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				float2 scrPos = i.scrPos;
				float2 centerScrPos = i.centerScrPos;
				//const fixed sub = 0.111111111111;
				//const fixed sub = 1 / 40;
				const fixed sub = 0.0166666666666667;
				fixed pos = 1;

				float m = _ObstacleMul*length((scrPos - centerScrPos)*/*fixed2(_ScreenParams.x / _ScreenParams.y, 1)**/sub);
				
				fixed4 col = tex2D (_MainTex, i.uv) * _ColorTint;
				if (tex2D(_ObstacleTex, centerScrPos).x > 0.1f) col.x = 0;
				if (tex2D(_ObstacleTex, centerScrPos).y > 0.1f) col.y = 0;
				if (tex2D(_ObstacleTex, centerScrPos).z > 0.1f) col.z = 0;

				//return tex2D(_ObstacleTex, i.uv);
				//if (scrPos.x > 0.5f) return float4(1,0,0,0);

				//for (int i = 0; i < 40; i++) {
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);

					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m); // 10

					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);

					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m); // 20

					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);

					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m); // 30

					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);

					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m); // 40

					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);

					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m); // 50

					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);

					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m);
					pos -= sub; col *= saturate(1 - tex2D(_ObstacleTex, lerp(centerScrPos, scrPos, pos))*m); // 60

				//}
				return col;
			}
			ENDCG
		}
	}
}
