Shader "Custom/warp"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _RampTex("RampTex",2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Test

        sampler2D _MainTex;
        sampler2D _RampTex;

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

        float4 LightingTest(SurfaceOutput s, float3 lightDir, float atten)
        {
            float ndotl = dot(s.Normal,lightDir) * 0.5 + 0.5;

            float4 ramp = tex2D(_RampTex,float2(ndotl,0.5));
            return ramp;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
