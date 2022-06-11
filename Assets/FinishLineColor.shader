Shader "Unlit/FinishLineColor"
{
    Properties
    {
        _ColorStart("Referance Color",Color)=(0,0,0,0)
        _ColorSaturate("Color Saturation",Range(0.01,0.99))=1
        _ColorBrightness("Color Brightness",Range(0.01,0.99))=1
        _Offset("Off set",Range(0,3))=2
        _LineColor("Line Color",Color)=(0,0,0,0)
        _LineCount("Line Count",int)=5
        _LineHeight("Line Height",Range(0.01,0.99))=0.1
        _Value("Value",Range(-0.5,0.5))=0
        
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
                
        Pass
        {
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float2 uv0 : TEXCOORD1;
            };

            struct Interpolator
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float2 uv0 : TEXCOORD1;
                float4 world_pos : TEXCOORD2;
                float4 object_pos : TEXCOORD3;

            };
            half4  _ColorStart;
            float _ColorSaturate;
            float _Offset;
            half4 _LineColor;
            int _LineCount;
            float _LineHeight;
            float _ColorBrightness;
            float _Value;

            

            Interpolator vert (appdata v)
            {
                Interpolator o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.world_pos = mul(unity_ObjectToWorld,v.vertex);
                o.object_pos = (mul(unity_WorldToObject,o.world_pos));
                return o;
            }
            float3 RGBToHSV(float3 c)
			{
				float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
				float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
				float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
				float d = q.x - min( q.w, q.y );
				float e = 1.0e-10;
				return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
			}
            float3 HSVToRGB( float3 c )
			{
				float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
				float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
				return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
			}

            fixed4 frag (Interpolator i) : SV_Target
            {
                float a = (i.object_pos.z);
                float4 colorConstant=_ColorStart;
                float3 color = RGBToHSV( colorConstant.rgb);
                float t = _Value>(a);
                color *= float3(a+_Offset,_ColorSaturate+t,_ColorBrightness);
                colorConstant.rgb= HSVToRGB(color);
                float3 outColor =lerp(_LineColor,colorConstant,step(_LineHeight,frac(i.object_pos.z*_LineCount+_LineHeight)));
                return float4(outColor,1);
   
            }
            ENDCG
        }
    }
}
