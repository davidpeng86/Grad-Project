// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "LavaShader"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			half filler;
		};

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17000
427;325;1371;641;3457.365;1259.185;4.25946;True;True
Node;AmplifyShaderEditor.RangedFloatNode;10;-1826.055,564.0036;Float;False;Property;_Float0;Float 0;0;0;Create;True;0;0;False;0;0.1;0.1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-1518.917,152.9283;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-1506.994,432.8876;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;12;-1812.405,365.2874;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;20;-1054.4,-9.676496;Float;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;6;-1071.336,292.4822;Float;True;0;0;1;0;1;False;1;False;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.RangedFloatNode;13;-1237.658,409.2075;Float;False;Constant;_Float1;Float 1;1;0;Create;True;0;0;False;0;-5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1241.003,107.5842;Float;False;Constant;_Float2;Float 2;1;0;Create;True;0;0;False;0;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-1289.58,592.6151;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;23;-1007.422,623.759;Float;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;8;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;18;-694.4137,222.056;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-397.9954,377.0155;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;27;-165.499,376.4791;Float;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;3;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;28;150.6311,419.8511;Float;True;5;0;COLOR;0,0,0,0;False;1;COLOR;0.1333333,0.1372549,0.1568628,0;False;2;COLOR;1,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;490.5781,137.2247;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;LavaShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;1;11;0
WireConnection;11;0;12;2
WireConnection;11;1;10;0
WireConnection;20;0;8;0
WireConnection;20;1;21;0
WireConnection;6;0;8;0
WireConnection;6;1;12;2
WireConnection;6;2;13;0
WireConnection;22;1;11;0
WireConnection;23;0;22;0
WireConnection;18;0;20;0
WireConnection;18;1;6;0
WireConnection;25;0;18;0
WireConnection;25;1;23;0
WireConnection;27;1;25;0
WireConnection;28;0;27;0
ASEEND*/
//CHKSM=3EC62FD45BC223CCA02D1C796EFF8D7941867971