Shader "Custom/CustomLambert"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Test

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;

            o.Alpha = c.a;
        }

        float4 LightingTest(SurfaceOutput s, float3 lightDir, float3 atten)
        {
            float4 ndotl = saturate(dot(s.Normal,lightDir));
            float4 final;
            final.rgb = ndotl * s.Albedo * _LightColor0.rgb * atten;
            final.a = s.Alpha;
            return final;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
