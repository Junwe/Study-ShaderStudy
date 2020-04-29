Shader "Custom/Rim"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _RimColor("RimColor",Color) = (1,1,1,1)
        _RimPower("RimPower",Range(1,10)) = 3
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert noambient alpha:fade

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0


        sampler2D _MainTex;
        float4 _RimColor;
        float _RimPower;

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
            float3 worldPos;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            float rim = dot(o.Normal, IN.viewDir);

            o.Emission =  _RimColor.rgb;
            rim = pow(1 - rim,_RimPower) + pow(frac(IN.worldPos.g * 3 - _Time.y),30);
            o.Alpha = rim * abs(sin(_Time.y));
        }
        ENDCG
    }
    FallBack "Diffuse"
}
