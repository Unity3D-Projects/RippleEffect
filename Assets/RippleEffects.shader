﻿Shader "Custom/Ripple Effects"
{
    Properties
    {
        _MainTex("Base (RGB)", 2D) = "white" {}
        _Params("Parameters", Vector) = (1, 1, 1, 1)
        _Drop1("Drop 1", Vector) = (0.333, 0.333, 0, 0)
        _Drop2("Drop 2", Vector) = (0.666, 0.666, 0, 0)
    }

    CGINCLUDE

    #include "UnityCG.cginc"

    struct v2f
    {
        float4 position : SV_POSITION;
        float2 uv : TEXCOORD0;
    };

    sampler2D _MainTex;
    float4 _Params;
    float3 _Drop1;
    float3 _Drop2;

    v2f vert(appdata_img v)
    {
        v2f o;
        o.position = mul(UNITY_MATRIX_MVP, v.vertex);
        o.uv = v.texcoord.xy;
        return o;
    }

    float wave(float2 position, float2 origin, float time)
    {
        float d = length(position - origin);
        float t = max(time * _Params.x - d, 0);
        return 0.2f * sin(t * _Params.z * 2 * 3.14159265f) * exp(-_Params.y * t);
    }

    half4 frag(v2f i) : SV_Target
    {
        return
            wave(i.uv, _Drop1.xy, _Drop1.z) +
            wave(i.uv, _Drop2.xy, _Drop2.z) +
            0.5f;
    }

    ENDCG

    SubShader
    {
        Pass
        {
            ZTest Always Cull Off ZWrite Off
            Fog { Mode off }
            CGPROGRAM
            #pragma fragmentoption ARB_precision_hint_fastest 
            #pragma vertex vert
            #pragma fragment frag
            ENDCG
        }
    } 
}
