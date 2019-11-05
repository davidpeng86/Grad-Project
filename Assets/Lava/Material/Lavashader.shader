// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "LavaShader"
{
	Properties
	{
		_BallColor("BallColor", Color) = (0,0,0,0)
		_NoiseColor("NoiseColor", Color) = (0.240137,0,0.990566,1)
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
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _NoiseColor;
		uniform float4 _BallColor;


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
					o = ( sin( _Time.x + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = g - f + o;
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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float temp_output_11_0 = ( 0.5 * _Time.x );
			float2 temp_cast_0 = (temp_output_11_0).xx;
			float2 uv_TexCoord8 = i.uv_texcoord + temp_cast_0;
			float simplePerlin2D20 = snoise( uv_TexCoord8*10.0 );
			simplePerlin2D20 = simplePerlin2D20*0.5 + 0.5;
			float4 temp_output_51_0 = ( _NoiseColor * simplePerlin2D20 );
			float2 coords6 = uv_TexCoord8 * -10.0;
			float2 id6 = 0;
			float voroi6 = voronoi6( coords6, id6 );
			float4 temp_output_53_0 = ( _BallColor * ( 1.0 - voroi6 ) );
			o.Albedo = ( temp_output_51_0 * temp_output_53_0 ).rgb;
			o.Emission = ( temp_output_51_0 + temp_output_53_0 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17000
-1433;7;1426;824;2901.469;969.59;2.707261;True;False
Node;AmplifyShaderEditor.TimeNode;12;-1957.45,279.9167;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;-1993.537,79.26486;Float;False;Constant;_Float0;Float 0;0;0;Create;True;0;0;False;0;0.5;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-1701.307,160.8451;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1345.268,431.0019;Float;False;Constant;_Float1;Float 1;1;0;Create;True;0;0;False;0;-10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-1518.917,152.9283;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;6;-1140.267,257.428;Float;True;0;0;1;0;1;False;1;False;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.RangedFloatNode;21;-1208.003,166.5842;Float;False;Constant;_Float2;Float 2;1;0;Create;True;0;0;False;0;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;55;-886.9395,257.3673;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;56;-719.1872,5.195473;Float;False;Property;_BallColor;BallColor;0;0;Create;True;0;0;False;0;0,0,0,0;0.9607843,0.2479979,0.1137254,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;20;-1026.4,-50.67649;Float;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;49;-676.8912,-426.227;Float;False;Property;_NoiseColor;NoiseColor;1;0;Create;True;0;0;False;0;0.240137,0,0.990566,1;0.6509434,0.4033296,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;59;158.1356,-267.9163;Float;False;285;303;Multiply darkens the color;1;52;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-388.5583,102.0527;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-356.9322,-286.094;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;58;266.2333,74.53404;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GradientNode;41;-896.7336,801.6845;Float;False;0;2;2;1,0,0,0;1,0.4934974,0,1;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;23;-1252.963,-259.4948;Float;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;8;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-1520.905,-75.44132;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;48;-964.1698,-709.9622;Float;False;Constant;_Float4;Float 4;1;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GradientSampleNode;50;-630.2297,-783.4532;Float;True;2;0;OBJECT;0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;46;-891.8232,891.8962;Float;False;Constant;_Float3;Float 3;1;0;Create;True;0;0;False;0;2.07;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-126.9052,521.3805;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;208.1356,-217.9165;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GradientSampleNode;45;-686.0851,833.7689;Float;True;2;0;OBJECT;0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GradientNode;47;-969.0804,-800.1735;Float;False;0;2;2;1,0,0,0;1,0.5302032,0,1;0.372549,0;0.6470588,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.ColorNode;42;-536.3707,476.4747;Float;False;Constant;_Tint;Tint;0;0;Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;603.0308,22.3322;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;LavaShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;11;0;10;0
WireConnection;11;1;12;1
WireConnection;8;1;11;0
WireConnection;6;0;8;0
WireConnection;6;1;12;1
WireConnection;6;2;13;0
WireConnection;55;0;6;0
WireConnection;20;0;8;0
WireConnection;20;1;21;0
WireConnection;53;0;56;0
WireConnection;53;1;55;0
WireConnection;51;0;49;0
WireConnection;51;1;20;0
WireConnection;58;0;51;0
WireConnection;58;1;53;0
WireConnection;23;0;22;0
WireConnection;22;1;11;0
WireConnection;50;0;47;0
WireConnection;50;1;48;0
WireConnection;43;0;53;0
WireConnection;43;1;42;0
WireConnection;52;0;51;0
WireConnection;52;1;53;0
WireConnection;45;0;41;0
WireConnection;45;1;46;0
WireConnection;0;0;52;0
WireConnection;0;2;58;0
ASEEND*/
//CHKSM=41671A6F1249E8AA572A806AEC37ADB73FFBC661