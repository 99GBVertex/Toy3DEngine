#define _DXC 1

// Vertex input
struct VertexInput
{
    [[vk::location(0)]] float3 position : POSITION0;
    [[vk::location(1)]] float3 color : COLOR0;
    [[vk::location(2)]] float3 normal : NORMAL0;
    [[vk::location(3)]] float2 uv : TEXCOORD0;
};

// Vertex output
struct VertexOutput
{
    [[vk::location(0)]] float3 fragColor : TEXCOORD0;
    [[vk::location(1)]] float2 fragTexCoord : TEXCOORD1;
    float4 position : SV_POSITION;
};

struct GlobalBuffer
{
    float4x4 projectionViewMatrix;
    float3 lightDirection;
};

struct Push
{
    float4x4 modelMatrix;
    float4x4 normalMatrix;
};

#ifdef _DXC
GlobalBuffer ubo : register(b0);
[[vk::push_constant]] Push push;
#else
ConstantBuffer<GlobalBuffer> ubo : register(b0);
[[vk::push_constant]] ConstantBuffer<Push> push;
#endif

sampler texSampler : register(s1);

VertexOutput VSMain(VertexInput In)
{
    VertexOutput Out;

    Out.position = mul(ubo.projectionViewMatrix, mul(push.modelMatrix, float4(In.position, 1.0)));

    float4 normalWorldSpace = normalize(mul(push.normalMatrix, float4(In.normal, 1.0)));

    float lightIntensity = 0.02 + max(dot(normalWorldSpace, float4(ubo.lightDirection, 1.0)), 0);

    Out.fragColor = lightIntensity * In.color;
    Out.fragTexCoord = In.uv;
	
    return Out;
}

float4 PSMain(VertexOutput input) : SV_TARGET
{
    Texture2D meshTexture;
    float4 color = meshTexture.Sample(texSampler, input.fragTexCoord.xy);
    
    return color;
}