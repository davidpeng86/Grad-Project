// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Distortion"
{
	Properties
	{
		_blending("blending", Range( 0 , 1)) = 0
		_DistortionMap("DistortionMap", 2D) = "bump" {}
		_DistortionScale("DistortionScale", Range( 0 , 1)) = 0
		_RippleScale("RippleScale", Range( 0 , 20)) = 0
		_RippleSpeed("RippleSpeed", Range( 0 , 2)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		GrabPass{ }
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float4 screenPos;
		};

		uniform sampler2D _GrabTexture;
		uniform sampler2D _DistortionMap;
		uniform float _RippleScale;
		uniform float _RippleSpeed;
		uniform float _DistortionScale;
		uniform float _blending;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Albedo = float3(0,0,0);
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 screenColor2 = tex2D( _GrabTexture, ( float4( ( UnpackNormal( tex2D( _DistortionMap, ( _RippleScale * (( ( _Time.y * _RippleSpeed ) + ase_grabScreenPosNorm )).xy ) ) ) * _DistortionScale ) , 0.0 ) + ase_grabScreenPosNorm ).xy );
			float4 temp_cast_2 = (1.0).xxxx;
			float4 lerpResult3 = lerp( screenColor2 , temp_cast_2 , _blending);
			o.Emission = lerpResult3.rgb;
			o.Metallic = lerpResult3.r;
			o.Smoothness = lerpResult3.r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15401
9;64;1426;824;1138.791;361.4614;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;17;-2269.932,-99.68647;Float;False;Property;_RippleSpeed;RippleSpeed;4;0;Create;True;0;0;False;0;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;11;-2202.531,-256.9893;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-1989.131,-150.3869;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;8;-2078.536,29.90393;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-1837.029,-85.38708;Float;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SwizzleNode;12;-1711.124,-217.9894;Float;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-1822.724,-290.7878;Float;False;Property;_RippleScale;RippleScale;3;0;Create;True;0;0;False;0;0;0;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-1531.525,-285.5876;Float;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;6;-1386.421,-314.4026;Float;True;Property;_DistortionMap;DistortionMap;1;0;Create;True;0;0;False;0;dd2fd2df93418444c8e280f1d34deeb5;dd2fd2df93418444c8e280f1d34deeb5;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;-1354.132,-111.7956;Float;False;Property;_DistortionScale;DistortionScale;2;0;Create;True;0;0;False;0;0;0.41;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-1045.029,-128.696;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-850.0255,7.804379;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-681.4199,169.6968;Float;False;Property;_blending;blending;0;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-544.4199,76.69681;Float;False;Constant;_transition;transition;0;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;2;-711.4199,2.696808;Float;False;Global;_GrabScreen0;Grab Screen 0;0;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;1;-453.4199,-149.3032;Float;False;Constant;_Vector0;Vector 0;0;0;Create;True;0;0;False;0;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;3;-332.4199,6.696808;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-67,-54;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Distortion;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Translucent;0.5;True;True;0;False;Opaque;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;16;0;11;2
WireConnection;16;1;17;0
WireConnection;15;0;16;0
WireConnection;15;1;8;0
WireConnection;12;0;15;0
WireConnection;13;0;14;0
WireConnection;13;1;12;0
WireConnection;6;1;13;0
WireConnection;9;0;6;0
WireConnection;9;1;10;0
WireConnection;7;0;9;0
WireConnection;7;1;8;0
WireConnection;2;0;7;0
WireConnection;3;0;2;0
WireConnection;3;1;4;0
WireConnection;3;2;5;0
WireConnection;0;0;1;0
WireConnection;0;2;3;0
WireConnection;0;3;3;0
WireConnection;0;4;3;0
ASEEND*/
//CHKSM=28598F29FA1A9B2A73FB336584E8365F9201D692