// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "LavaWithRim"
{
	Properties
	{
		[HDR]_BallColor("BallColor", Color) = (0,0,0,0)
		[HDR]_Rim("Rim", Color) = (0,0,0,0)
		_X_RollSpeed("X_RollSpeed", Range( -1 , 1)) = 0.5
		_Fresnel("Fresnel", Float) = 1
		_Y_RollSpeed("Y_RollSpeed", Range( -1 , 1)) = 0.5
		_Power("Power", Float) = 0
		_WaveSpeed("WaveSpeed", Float) = 5
		_Contrast("Contrast", Range( 0 , 1)) = 1
		_Depth("Depth", Range( -1 , 5)) = 0
		_FarColorPwr("FarColorPwr", Float) = 0
		_frenelShow("frenelShow", Float) = -0.01
		_ShieldPatternWaves("Shield Pattern Waves", 2D) = "white" {}
		_waveHeight("waveHeight", Float) = 3
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			float4 screenPos;
		};

		uniform float _waveHeight;
		uniform sampler2D _ShieldPatternWaves;
		uniform float _WaveSpeed;
		uniform float _X_RollSpeed;
		uniform float _Y_RollSpeed;
		uniform float4 _BallColor;
		uniform float _Power;
		uniform float _Contrast;
		uniform float4 _Rim;
		uniform float _frenelShow;
		uniform float _Fresnel;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _Depth;
		uniform float _FarColorPwr;


		float2 voronoihash64( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi64( float2 v, inout float2 id )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mr = 0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash64( n + g );
					o = ( sin( _Time.y + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = g - f + o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return F1;
		}


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float2 appendResult107 = (float2(1 , ( 1.0 - ( _Time.y / _WaveSpeed ) )));
			float2 uv_TexCoord110 = v.texcoord.xy * float2( 1,-1 ) + appendResult107;
			v.vertex.xyz += ( float4( ( ase_vertexNormal * _waveHeight ) , 0.0 ) * tex2Dlod( _ShieldPatternWaves, float4( uv_TexCoord110, 0, 1.0) ) ).rgb;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 appendResult61 = (float2(( _X_RollSpeed * _Time.x ) , ( _Y_RollSpeed * _Time.x )));
			float2 uv_TexCoord63 = i.uv_texcoord + appendResult61;
			float2 coords64 = uv_TexCoord63 * -25.0;
			float2 id64 = 0;
			float voroi64 = voronoi64( coords64, id64 );
			float4 temp_cast_0 = (_Power).xxxx;
			float simplePerlin2D71 = snoise( uv_TexCoord63*80.0 );
			simplePerlin2D71 = simplePerlin2D71*0.5 + 0.5;
			float4 temp_cast_1 = (( simplePerlin2D71 * _Contrast )).xxxx;
			o.Albedo = ( pow( ( ( 1.0 - voroi64 ) * _BallColor ) , temp_cast_0 ) - temp_cast_1 ).rgb;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV48 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode48 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV48, (0.0 + (_Fresnel - 0.0) * (1.0 - 0.0) / (1.0 - 0.0)) ) );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth44 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth44 = abs( ( screenDepth44 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _Depth ) );
			float clampResult43 = clamp( distanceDepth44 , 0.0 , 1.0 );
			float4 lerpResult49 = lerp( _Rim , ( ( _Rim + _frenelShow ) * fresnelNode48 ) , clampResult43);
			o.Emission = ( lerpResult49 * _FarColorPwr ).rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 screenPos : TEXCOORD3;
				float3 worldNormal : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17000
1921;1;1918;1056;2880.972;724.3179;2.490273;True;False
Node;AmplifyShaderEditor.CommentaryNode;53;-3903.934,-1024.316;Float;False;1157.971;698.3502;Animation Function;8;63;61;59;58;57;56;55;54;;0,0.5001211,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-3853.934,-973.7219;Float;False;Property;_X_RollSpeed;X_RollSpeed;2;0;Create;True;0;0;False;0;0.5;0.3;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;57;-3780.988,-504.9644;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;56;-3841.676,-619.1509;Float;False;Property;_Y_RollSpeed;Y_RollSpeed;4;0;Create;True;0;0;False;0;0.5;0.3;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;55;-3793.369,-820.8543;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-3391.352,-941.3995;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-3439.384,-657.9269;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;101;-2005.257,1213.87;Float;False;1608.543;477.595;Comment;13;114;113;112;111;110;109;108;107;106;105;104;103;102;Shield Wave Effect;1,1,1,1;0;0
Node;AmplifyShaderEditor.TimeNode;103;-1996.397,1378.29;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;60;-2633.643,-1009.582;Float;False;641.0369;628.2033;Noise;4;71;66;64;62;;0.4464631,1,0,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;61;-3202.61,-765.3444;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;102;-1968.051,1575.187;Float;False;Property;_WaveSpeed;WaveSpeed;6;0;Create;True;0;0;False;0;5;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-2566.662,-526.7739;Float;False;Constant;_Float1;Float 1;1;0;Create;True;0;0;False;0;-25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;63;-3002.694,-726.2911;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;104;-1747.424,1503.725;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-1573.568,338.2694;Float;False;Property;_Fresnel;Fresnel;3;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;106;-1607.668,1507.406;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;105;-1637.038,1335.727;Float;False;Constant;_Vector2;Vector 2;7;0;Create;True;0;0;False;0;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;45;-1438.795,522.9552;Float;False;Property;_Depth;Depth;8;0;Create;True;0;0;False;0;0;0;-1;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;99;-1156.619,208.6151;Float;False;Property;_frenelShow;frenelShow;10;0;Create;True;0;0;False;0;-0.01;-0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;46;-1266.769,342.7881;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;65;-1969.006,-1066.776;Float;False;1361.777;874.5957;Comment;8;84;75;74;72;69;68;67;70;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;97;-1166.267,23.06437;Float;False;Property;_Rim;Rim;1;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0.4669811,0.1745409,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;64;-2271.796,-639.2929;Float;True;0;0;1;0;1;False;1;False;3;0;FLOAT2;0,0;False;1;FLOAT;0.36;False;2;FLOAT;1;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.SimpleAddOpNode;100;-906.2709,190.6472;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;48;-980.6321,310.7443;Float;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;67;-1812.659,-604.267;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;68;-1901.101,-498.8178;Float;False;Property;_BallColor;BallColor;0;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0.4669811,0.1745409,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;66;-2556.404,-853.7808;Float;False;Constant;_Float2;Float 2;1;0;Create;True;0;0;False;0;80;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;107;-1420.404,1476.577;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;108;-1414.736,1263.87;Float;False;Constant;_Vector3;Vector 3;7;0;Create;True;0;0;False;0;1,-1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DepthFade;44;-1093.736,516.0502;Float;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;110;-1225.951,1441.711;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;109;-1014.518,1331.601;Float;False;Property;_waveHeight;waveHeight;12;0;Create;True;0;0;False;0;3;3.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;111;-1213.32,1250.618;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-1482.185,-603.1537;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;43;-761.5717,506.6855;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-694.2273,282.3449;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-1781.361,-786.2116;Float;False;Property;_Contrast;Contrast;7;0;Create;True;0;0;False;0;1;0.266;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;71;-2284.262,-942.3572;Float;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-1461.912,-321.0025;Float;False;Property;_Power;Power;5;0;Create;True;0;0;False;0;0;1.78;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;112;-981.4948,1444.248;Float;True;Property;_ShieldPatternWaves;Shield Pattern Waves;11;0;Create;True;0;0;False;0;None;61c0b9c0523734e0e91bc6043c72a490;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;75;-1197.991,-569.9249;Float;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.72;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-428.7734,404.3523;Float;False;Property;_FarColorPwr;FarColorPwr;9;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;49;-377.0966,111.2439;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;-802.1556,1253.564;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-1115.476,-964.394;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;94;-39.07968,121.179;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;84;-823.9955,-524.0566;Float;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-661.2706,1331.463;Float;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;333.1065,61.39784;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;LavaWithRim;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;59;0;54;0
WireConnection;59;1;55;1
WireConnection;58;0;56;0
WireConnection;58;1;57;1
WireConnection;61;0;59;0
WireConnection;61;1;58;0
WireConnection;63;1;61;0
WireConnection;104;0;103;2
WireConnection;104;1;102;0
WireConnection;106;0;104;0
WireConnection;46;0;47;0
WireConnection;64;0;63;0
WireConnection;64;1;55;2
WireConnection;64;2;62;0
WireConnection;100;0;97;0
WireConnection;100;1;99;0
WireConnection;48;3;46;0
WireConnection;67;0;64;0
WireConnection;107;0;105;1
WireConnection;107;1;106;0
WireConnection;44;0;45;0
WireConnection;110;0;108;0
WireConnection;110;1;107;0
WireConnection;69;0;67;0
WireConnection;69;1;68;0
WireConnection;43;0;44;0
WireConnection;52;0;100;0
WireConnection;52;1;48;0
WireConnection;71;0;63;0
WireConnection;71;1;66;0
WireConnection;112;1;110;0
WireConnection;75;0;69;0
WireConnection;75;1;72;0
WireConnection;49;0;97;0
WireConnection;49;1;52;0
WireConnection;49;2;43;0
WireConnection;113;0;111;0
WireConnection;113;1;109;0
WireConnection;74;0;71;0
WireConnection;74;1;70;0
WireConnection;94;0;49;0
WireConnection;94;1;95;0
WireConnection;84;0;75;0
WireConnection;84;1;74;0
WireConnection;114;0;113;0
WireConnection;114;1;112;0
WireConnection;0;0;84;0
WireConnection;0;2;94;0
WireConnection;0;11;114;0
ASEEND*/
//CHKSM=CF9A84CA20CC34A1FE1271F527D94ED694954B86