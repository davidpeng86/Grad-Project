// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "LavaShader"
{
	Properties
	{
		[HDR]_BallColor("BallColor", Color) = (0,0,0,0)
		_X_RollSpeed("X_RollSpeed", Range( -1 , 1)) = 0.5
		_Y_RollSpeed("Y_RollSpeed", Range( -1 , 1)) = 0.5
		_Power("Power", Float) = 0
		_Contrast("Contrast", Range( 0 , 1)) = 0
		_WaveSpeed("WaveSpeed", Float) = 5
		_ShieldPatternWaves("Shield Pattern Waves", 2D) = "white" {}
		_waveHeight("waveHeight", Float) = 3
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _waveHeight;
		uniform sampler2D _ShieldPatternWaves;
		uniform float _WaveSpeed;
		uniform float _X_RollSpeed;
		uniform float _Y_RollSpeed;
		uniform float _Contrast;
		uniform float4 _BallColor;
		uniform float _Power;


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


		float2 voronoihash6( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi6( float2 v, inout float2 id )
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
			 		float2 o = voronoihash6( n + g );
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


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float2 appendResult140 = (float2(1 , ( 1.0 - ( _Time.y / _WaveSpeed ) )));
			float2 uv_TexCoord141 = v.texcoord.xy * float2( 1,1 ) + appendResult140;
			float4 waves143 = ( float4( ( ase_vertexNormal * _waveHeight ) , 0.0 ) * tex2Dlod( _ShieldPatternWaves, float4( uv_TexCoord141, 0, 1.0) ) );
			v.vertex.xyz += waves143.rgb;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 appendResult104 = (float2(( _X_RollSpeed * _Time.x ) , ( _Y_RollSpeed * _Time.x )));
			float2 uv_TexCoord8 = i.uv_texcoord + appendResult104;
			float simplePerlin2D20 = snoise( uv_TexCoord8*80.0 );
			simplePerlin2D20 = simplePerlin2D20*0.5 + 0.5;
			float temp_output_51_0 = ( simplePerlin2D20 * _Contrast );
			float3 temp_cast_0 = (temp_output_51_0).xxx;
			o.Albedo = temp_cast_0;
			float2 coords6 = uv_TexCoord8 * -25.0;
			float2 id6 = 0;
			float voroi6 = voronoi6( coords6, id6 );
			float4 temp_cast_1 = (_Power).xxxx;
			float4 temp_cast_2 = (temp_output_51_0).xxxx;
			float4 temp_output_66_0 = ( pow( ( ( 1.0 - voroi6 ) * _BallColor ) , temp_cast_1 ) - temp_cast_2 );
			o.Emission = temp_output_66_0.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17000
1927;35;1906;1016;2927.795;364.5791;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;110;-3551.6,-438.0503;Float;False;1157.971;698.3502;Animation Function;8;11;104;8;102;101;12;10;103;;0,0.5001211,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;133;-3434.102,-1123.297;Float;False;1608.543;477.595;Comment;14;143;142;141;140;139;138;137;136;135;151;152;153;154;155;Shield Wave Effect;1,1,1,1;0;0
Node;AmplifyShaderEditor.TimeNode;151;-3425.243,-958.8769;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;-3501.6,-387.4561;Float;False;Property;_X_RollSpeed;X_RollSpeed;2;0;Create;True;0;0;False;0;0.5;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;135;-3396.896,-761.9802;Float;False;Property;_WaveSpeed;WaveSpeed;6;0;Create;True;0;0;False;0;5;30.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;102;-3428.654,81.30026;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;101;-3489.343,-32.88591;Float;False;Property;_Y_RollSpeed;Y_RollSpeed;3;0;Create;True;0;0;False;0;0.5;-1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;12;-3441.035,-234.5886;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-3039.018,-355.1336;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;136;-3176.27,-833.4425;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;-3087.05,-71.66203;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;138;-3036.514,-829.7618;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;111;-2281.308,-423.3161;Float;False;641.0369;628.2033;Noise;4;6;13;21;20;;0.4464631,1,0,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;104;-2850.275,-179.0791;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;137;-3065.884,-1001.44;Float;False;Constant;_Vector2;Vector 2;7;0;Create;True;0;0;False;0;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-2653.623,-388.0503;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;13;-2224.118,-211.3796;Float;False;Constant;_Float1;Float 1;1;0;Create;True;0;0;False;0;-25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;139;-2843.582,-1073.297;Float;False;Constant;_Vector3;Vector 3;7;0;Create;True;0;0;False;0;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;140;-2849.25,-860.5902;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NormalVertexDataNode;153;-2642.165,-1086.549;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;141;-2654.797,-895.4565;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;155;-2443.364,-1005.566;Float;False;Property;_waveHeight;waveHeight;11;0;Create;True;0;0;False;0;3;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;6;-1922.725,-346.743;Float;True;0;0;1;0;1;False;1;False;3;0;FLOAT2;0,0;False;1;FLOAT;0.36;False;2;FLOAT;1;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.CommentaryNode;112;-1616.672,-480.5099;Float;False;1361.777;874.5957;Comment;8;64;51;113;56;55;53;63;66;;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;55;-1453.798,-347.6166;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-2210.596,78.41711;Float;False;Constant;_Float2;Float 2;1;0;Create;True;0;0;False;0;80;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;56;-1542.241,-242.1677;Float;False;Property;_BallColor;BallColor;1;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0.4669811,0.1745409,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;142;-2410.34,-892.9189;Float;True;Property;_ShieldPatternWaves;Shield Pattern Waves;10;0;Create;True;0;0;False;0;None;61c0b9c0523734e0e91bc6043c72a490;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;154;-2231.001,-1083.603;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;20;-1938.454,-10.15906;Float;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-1123.325,-346.5034;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;113;-1523.667,185.1486;Float;False;Property;_Contrast;Contrast;5;0;Create;True;0;0;False;0;0;0.266;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-1103.052,-64.35267;Float;False;Property;_Power;Power;4;0;Create;True;0;0;False;0;0;1.78;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;152;-2090.116,-1005.704;Float;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-979.8995,26.80373;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;145;-2544.015,473.0844;Float;False;828.5967;315.5001;Screen depth difference to get intersection and fading effect with terrain and objects;4;149;148;147;146;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PowerNode;63;-839.1307,-313.2746;Float;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.72;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;143;-1942.6,-1005.28;Float;False;waves;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;125;-1041.29,769.4575;Float;False;Property;_FresnelPower;Fresnel Power;7;0;Create;True;0;0;False;0;8.205107;1;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;146;-2494.015,576.5845;Float;False;1;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;130;-1433.665,578.3478;Float;False;Global;_GrabScreen0;Grab Screen 0;12;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;124;-240.9471,537.0697;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;119;-1496.678,784.3936;Float;False;Property;_Offset;Offset;8;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;144;157.7312,617.1119;Float;False;143;waves;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;123;-505.4494,536.6932;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;127;-247.4573,330.3277;Float;False;Property;_fresnelColor;fresnelColor;9;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;148;-2064.615,619.3846;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;120;-911.04,537.1026;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;122;-772.9384,538.2838;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;114;-613.0898,682.4384;Float;True;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;147;-2272.015,574.0844;Float;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;118;-1176.862,675.2545;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;66;-465.1351,-267.4064;Float;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.AbsOpNode;149;-1879.418,617.2007;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;129;229.6642,197.4699;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;17.77322,312.2208;Float;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenDepthNode;121;-1188.678,493.6932;Float;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;603.0308,22.3322;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;LavaShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;11;0;10;0
WireConnection;11;1;12;1
WireConnection;136;0;151;2
WireConnection;136;1;135;0
WireConnection;103;0;101;0
WireConnection;103;1;102;1
WireConnection;138;0;136;0
WireConnection;104;0;11;0
WireConnection;104;1;103;0
WireConnection;8;1;104;0
WireConnection;140;0;137;1
WireConnection;140;1;138;0
WireConnection;141;0;139;0
WireConnection;141;1;140;0
WireConnection;6;0;8;0
WireConnection;6;1;12;2
WireConnection;6;2;13;0
WireConnection;55;0;6;0
WireConnection;142;1;141;0
WireConnection;154;0;153;0
WireConnection;154;1;155;0
WireConnection;20;0;8;0
WireConnection;20;1;21;0
WireConnection;53;0;55;0
WireConnection;53;1;56;0
WireConnection;152;0;154;0
WireConnection;152;1;142;0
WireConnection;51;0;20;0
WireConnection;51;1;113;0
WireConnection;63;0;53;0
WireConnection;63;1;64;0
WireConnection;143;0;152;0
WireConnection;130;0;146;0
WireConnection;124;0;123;0
WireConnection;124;1;114;0
WireConnection;123;0;122;0
WireConnection;148;0;147;0
WireConnection;148;1;146;4
WireConnection;120;0;121;0
WireConnection;120;1;118;0
WireConnection;122;0;120;0
WireConnection;114;3;125;0
WireConnection;147;0;146;0
WireConnection;118;0;130;4
WireConnection;118;1;119;0
WireConnection;66;0;63;0
WireConnection;66;1;51;0
WireConnection;149;0;148;0
WireConnection;129;0;66;0
WireConnection;129;1;126;0
WireConnection;126;0;51;0
WireConnection;126;1;127;0
WireConnection;126;2;124;0
WireConnection;0;0;51;0
WireConnection;0;2;66;0
WireConnection;0;11;144;0
ASEEND*/
//CHKSM=00187B00E943671A3F71D6B6210A0E457405A3B3