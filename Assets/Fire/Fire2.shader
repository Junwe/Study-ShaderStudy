Shader "Custom/Rim"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Color("Color",Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard Lambert noambient alpha:fade


        sampler2D _MainTex;
        float4 _Color;

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
            float3 worldPos;
        };

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex );
            //o.Albedo = c.rgb;
            float rim = saturate(dot(o.Normal, IN.viewDir));
            rim = pow(1-rim,3) + pow(frac(IN.worldPos.g * 3 - _Time.y),30);
            o.Emission = float3(0,1,0);
            o.Alpha = rim;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
