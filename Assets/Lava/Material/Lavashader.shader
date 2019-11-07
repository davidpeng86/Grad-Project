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
		_WaveSpeed("WaveSpeed", Range( 0 , 1)) = 1.003595
		_DistortionScale("Distortion Scale", Range( -10 , 10)) = 0
		_Contrast("Contrast", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _WaveSpeed;
		uniform float _DistortionScale;
		uniform float _Contrast;
		uniform float _X_RollSpeed;
		uniform float _Y_RollSpeed;
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
			float2 temp_cast_0 = (( _Time.y * _WaveSpeed )).xx;
			float2 uv_TexCoord86 = v.texcoord.xy + temp_cast_0;
			float simplePerlin2D87 = snoise( uv_TexCoord86*_DistortionScale );
			simplePerlin2D87 = simplePerlin2D87*0.5 + 0.5;
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 Distortion99 = ( ( ase_vertexNormal * simplePerlin2D87 ) + ase_vertex3Pos );
			v.vertex.xyz += Distortion99;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 appendResult104 = (float2(( _X_RollSpeed * _Time.x ) , ( _Y_RollSpeed * _Time.x )));
			float2 uv_TexCoord8 = i.uv_texcoord + appendResult104;
			float simplePerlin2D20 = snoise( uv_TexCoord8*20.0 );
			simplePerlin2D20 = simplePerlin2D20*0.5 + 0.5;
			float temp_output_51_0 = ( _Contrast * simplePerlin2D20 );
			float3 temp_cast_0 = (temp_output_51_0).xxx;
			o.Albedo = temp_cast_0;
			float2 coords6 = uv_TexCoord8 * -25.0;
			float2 id6 = 0;
			float voroi6 = voronoi6( coords6, id6 );
			float4 temp_output_53_0 = ( _BallColor * ( 1.0 - voroi6 ) );
			float4 temp_cast_1 = (_Power).xxxx;
			float4 temp_cast_2 = (temp_output_51_0).xxxx;
			o.Emission = ( pow( temp_output_53_0 , temp_cast_1 ) - temp_cast_2 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17000
44;271;1906;1004;1529.83;415.1602;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;110;-2923.694,36.52832;Float;False;1157.971;698.3502;Animation Function;8;11;104;8;102;101;12;10;103;;0,0.5001211,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;101;-2861.437,441.6927;Float;False;Property;_Y_RollSpeed;Y_RollSpeed;2;0;Create;True;0;0;False;0;0.5;-1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-2873.694,87.12247;Float;False;Property;_X_RollSpeed;X_RollSpeed;1;0;Create;True;0;0;False;0;0.5;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;85;-356.0107,860.2388;Float;False;2080.763;616.8013;Distortion;11;96;87;86;82;83;81;88;98;97;99;100;;0.9056604,0.6422486,0.1153435,1;0;0
Node;AmplifyShaderEditor.TimeNode;102;-2800.748,555.8789;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;12;-2813.129,239.9901;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;-2459.144,402.9166;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-2411.112,119.445;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;81;-288.8091,1057.215;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;82;-319.3107,1229.522;Float;False;Property;_WaveSpeed;WaveSpeed;4;0;Create;True;0;0;False;0;1.003595;0.054;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;111;-1653.402,51.26255;Float;False;641.0369;628.2033;Noise;4;21;20;6;13;;0.4464631,1,0,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;104;-2222.369,295.4995;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;46.49744,1093.615;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-2025.717,86.52831;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;13;-1603.402,538.8293;Float;False;Constant;_Float1;Float 1;1;0;Create;True;0;0;False;0;-25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;100;144.6011,1237.274;Float;False;Property;_DistortionScale;Distortion Scale;5;0;Create;True;0;0;False;0;0;3.02;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;86;242.5003,1081.985;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;88;731.033,901.5762;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;6;-1302.009,403.4659;Float;True;0;0;1;0;1;False;1;False;3;0;FLOAT2;0,0;False;1;FLOAT;0.36;False;2;FLOAT;1;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.NoiseGeneratorNode;87;507.9856,1046.534;Float;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;112;-944.9587,-166.558;Float;False;1361.777;874.5957;Comment;10;56;55;53;64;51;59;63;66;61;113;;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;55;-857.2566,441.1447;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;97;807.7905,1180.254;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;56;-795.5043,223.9728;Float;False;Property;_BallColor;BallColor;0;1;[HDR];Create;True;0;0;False;0;0,0,0,0;4.237095,0.6211448,0.1109187,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;21;-1534.754,227.0331;Float;False;Constant;_Float2;Float 2;1;0;Create;True;0;0;False;0;20;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;941.095,972.228;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;20;-1276.365,101.2626;Float;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;98;1152.289,1136.055;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;113;-750.8296,-78.16022;Float;False;Property;_Contrast;Contrast;6;0;Create;True;0;0;False;0;0;0.334;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-464.876,320.8302;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-493.2122,593.0374;Float;False;Property;_Power;Power;3;0;Create;True;0;0;False;0;0;2.58;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-433.2499,-67.31656;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;59;81.8179,-49.13889;Float;False;285;303;Multiply darkens the color;1;52;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;99;1326.355,1146.874;Float;False;Distortion;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;63;-218.8438,396.3573;Float;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.72;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;61;-894.9587,542.7715;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-964.1698,-709.9622;Float;False;Constant;_Float4;Float 4;1;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GradientSampleNode;45;-686.0851,833.7689;Float;True;2;0;OBJECT;0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GradientNode;41;-896.7336,801.6845;Float;False;0;2;2;1,0,0,0;1,0.4934974,0,1;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-891.8232,891.8962;Float;False;Constant;_Float3;Float 3;1;0;Create;True;0;0;False;0;2.07;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GradientNode;47;-969.0804,-800.1735;Float;False;0;2;2;1,0,0,0;1,0.5302032,0,1;0.372549,0;0.6470588,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;131.8178,0.8608528;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;66;84.1032,389.9841;Float;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GradientSampleNode;50;-630.2297,-783.4532;Float;True;2;0;OBJECT;0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;84;458.9523,562.0329;Float;False;99;Distortion;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;603.0308,22.3322;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;LavaShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;103;0;101;0
WireConnection;103;1;102;1
WireConnection;11;0;10;0
WireConnection;11;1;12;1
WireConnection;104;0;11;0
WireConnection;104;1;103;0
WireConnection;83;0;81;2
WireConnection;83;1;82;0
WireConnection;8;1;104;0
WireConnection;86;1;83;0
WireConnection;6;0;8;0
WireConnection;6;1;12;2
WireConnection;6;2;13;0
WireConnection;87;0;86;0
WireConnection;87;1;100;0
WireConnection;55;0;6;0
WireConnection;96;0;88;0
WireConnection;96;1;87;0
WireConnection;20;0;8;0
WireConnection;20;1;21;0
WireConnection;98;0;96;0
WireConnection;98;1;97;0
WireConnection;53;0;56;0
WireConnection;53;1;55;0
WireConnection;51;0;113;0
WireConnection;51;1;20;0
WireConnection;99;0;98;0
WireConnection;63;0;53;0
WireConnection;63;1;64;0
WireConnection;61;0;6;0
WireConnection;45;0;41;0
WireConnection;45;1;46;0
WireConnection;52;0;51;0
WireConnection;52;1;53;0
WireConnection;66;0;63;0
WireConnection;66;1;51;0
WireConnection;50;0;47;0
WireConnection;50;1;48;0
WireConnection;0;0;51;0
WireConnection;0;2;66;0
WireConnection;0;11;84;0
ASEEND*/
//CHKSM=3D3C9CBC04E47F8AAB054288771AE8A7B7457045