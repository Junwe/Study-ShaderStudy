Shader "Custom/Customblending"
{
    Properties
    {
        _TintColor ("Color", Color) = (0.5,0.5,0.5,0.5)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
       _NoiseTex("Noise",2D) = "white"{} 
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" "ignoreProjector"="True" }
        zwrite off
        blend SrcAlpha OneMinusSrcAlpha
        cull off

        CGPROGRAM
        #pragma surface surf nolight keepalpha noforwardadd nolightmap noambient novertexlights noshadow 



        sampler2D _MainTex;
        sampler2D _NoiseTex;
        float4 _TintColor;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NoiseTex;
            float4 color:COLOR;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 n = tex2D(_NoiseTex,float2(IN.uv_NoiseTex.x,IN.uv_NoiseTex.y + _Time.y));
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex + float2(n.r,n.r-0.1));
            c = c* 2 * _TintColor * IN.color;
            o.Emission = c.rgb;
            o.Alpha = c.a;
        }

        float4 Lightingnolight(SurfaceOutput s, float3 lightDir, float atten)
        {
            return float4(s.Emission,s.Alpha);
        }
        ENDCG
    }
    FallBack "Legacy Shaders/Transparent/VertexLit"
}
