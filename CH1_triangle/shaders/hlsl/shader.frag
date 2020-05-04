struct PSInput
{
	float4 Position : SV_POSITION;
	float3 Color : COLOR;
};

float4 main(PSInput pin) : SV_TARGET
{
	return float4(pin.Color, 1.0);
}
