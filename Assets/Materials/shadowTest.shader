Shader "Custom/shadowTest"
{
    Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_MainTex ("Base (RGB)", 2D) = "white" {}
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM

        #pragma surface surf CSLambert

        sampler2D _MainTex;

        struct Input {
            float2 uv_MainTex;
        };

        half4 LightingCSLambert (SurfaceOutput s, half3 lightDir, half atten) {

            fixed diff = max (0, dot (s.Normal, lightDir));

            fixed4 c;
            c.rgb = atten * _LightColor0.rgb *s.Albedo * (diff  * 2);//

            c.a = s.Alpha;
            return c;
        }

        void surf (Input IN, inout SurfaceOutput o) {
            half4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

        ENDCG
    }

    Fallback "VertexLit"
}
