Shader "Custom/ColourTInt"
{
    Properties
    {
        MainTex ("Texture", 2D) = "white" {}
        _ColorTint ("Tint", Color) = (0.8, 1, 0.8, 1.0)
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        
        CGPROGRAM
        #pragma surface surf Lambert finalcolor: Color
        struct Input
        {
            float2 uv_Maintex;
        };
         fixed4 _ColorTint;
         void mycolor (Input IN, SurfaceOutput o, inout fixed4 color)
         {
             color *= _ColorTint;
         }
         sampler2D _Maintex;
         void surf (Input IN, inout SurfaceOutput o)
         {
             o.Albedo = tex2D (_Maintex, IN.uv_Maintex).rgb;
             o.Alpha = _ColorTint.a;
         }
        ENDCG
    }
    FallBack "Diffuse"
}
