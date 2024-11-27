Shader "Custom/BlinnPhong" {
    Properties{
        _Color("Main Color", Color) = (1,1,1,1)
        _SpecColor("Specular Color", Color) = (1,1,1,1)
        _Shininess("Shininess", Range(0.03, 1)) = 0.078125
        _MainTex("Base (RGB)", 2D) = "white" {}
    }
        SubShader{
            Pass {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #include "UnityCG.cginc"

                struct appdata {
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
                };

                struct v2f {
                    float4 pos : SV_POSITION;
                    float3 normalDir : TEXCOORD0;
                    float3 lightDir : TEXCOORD1;
                    float3 viewDir : TEXCOORD2;
                };

                uniform float4 _Color;
                uniform float4 _SpecColor;
                uniform float _Shininess;

                v2f vert(appdata v) {
                    v2f o;
                    o.pos = UnityObjectToClipPos(v.vertex);

                    float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                    o.normalDir = mul(unity_ObjectToWorld, float4(v.normal, 0.0)).xyz;
                    o.lightDir = normalize(_WorldSpaceLightPos0.xyz - worldPos);
                    o.viewDir = normalize(_WorldSpaceCameraPos - worldPos);
                    return o;
                }

                float4 frag(v2f i) : SV_Target {
                    float3 N = normalize(i.normalDir);
                    float3 L = normalize(i.lightDir);
                    float3 V = normalize(i.viewDir);

                    // Halfway vector for Blinn
                    float3 H = normalize(L + V);

                    // Diffuse
                    float NdotL = max(dot(N, L), 0.0);
                    float3 diffuse = NdotL * _Color.rgb;

                    // Specular (Blinn-Phong)
                    float NdotH = max(dot(N, H), 0.0);
                    float spec = pow(NdotH, _Shininess);
                    float3 specular = _SpecColor.rgb * spec;

                    return float4(diffuse + specular, 1.0);
                }
                ENDCG
            }
    }
}

