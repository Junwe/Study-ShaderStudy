Shader "Custom/CustomBlinnPhong"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _specCol("SpecColor",Color) = (1,1,1,1)
        _specPow("SpecPow",Range(10,100)) = 100
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Test


        sampler2D _MainTex;
        float _specPow;
        float4 _specCol;

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

        float4 LightingTest(SurfaceOutput s, float3 lightDir,float3 viewDir, float3 atten)
        {
            float3 DiffColor;
            float ndotl = saturate(dot(s.Normal,lightDir));
            float4 final;

            float3 SpecColor;
            float3 H = normalize(lightDir+viewDir);
            float spec = saturate(dot(H,s.Normal));
            spec = pow(spec,_specPow);
            SpecColor = spec * _specCol.rgb;

            float3 RimColor;
            float rim = dot(s.Normal,viewDir);
            float invrim = 1- rim;
            RimColor = pow(invrim,1) * float3(0.5,0.5,0.5);

            DiffColor = ndotl * s.Albedo * _LightColor0.rgb * atten;
            final.rgb = DiffColor + SpecColor.rgb + RimColor.rgb;
            final.a = s.Alpha;

            return final;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
