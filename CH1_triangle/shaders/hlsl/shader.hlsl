struct VSInput
{
	float2 Position : POSITION;
	float3 Color : COLOR;
};

struct VSOutput
{
	float4 Position : SV_POSITION;
	float3 Color : COLOR;
};

VSOutput vert(VSInput vin)
{
	VSOutput vout = (VSOutput)0;

	vout.Position = float4(vin.Position, 0.0, 1.0);
	vout.Color = vin.Color;

	return vout;
}

float4 frag(VSOutput pin) : SV_TARGET
{
	return float4(pin.Color, 1.0);
}
