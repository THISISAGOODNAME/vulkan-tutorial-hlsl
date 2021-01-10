struct VSInput
{
	float2 Position : POSITION;
	float3 Color : COLOR;
	uint vertId : SV_VertexID;
};

struct VSOutput
{
	float4 Position : SV_POSITION;
	float3 Color : COLOR;
};

const string first = "first string\n";
string second = "second string\n";

VSOutput vert(VSInput vin)
{
	VSOutput vout = (VSOutput)0;

	vout.Position = float4(vin.Position, 0.0, 1.0);
	vout.Color = vin.Color;

	if (vin.vertId == 0)
	{
		// CHECK:                OpExtension "SPV_KHR_non_semantic_info"
		// CHECK: [[set:%\d+]] = OpExtInstImport "NonSemantic.DebugPrintf"

		float myfloat = 3.1415f;
        int foo = -135;

        printf("Here are two float values %f, %f\n", 1.0, myfloat);

        printf("Here's a smaller float value %1.2f\n", myfloat);

        printf("Here's an integer %i with text before and after it\n", foo);

        foo = 256;
        printf("Here's an integer in octal %o and hex 0x%x\n", foo, foo);

        foo = -135;
        printf("%d is a negative integer\n", foo);

        float4 floatvec = float4(1.2f, 2.2f, 3.2f, 4.2f);
        printf("Here's a vector of floats %1.2v4f\n", floatvec);

        printf("Here's a float in sn %e\n", myfloat);

        printf("Here's a float in sn %1.2e\n", myfloat);

        printf("Here's a float in shortest %g\n", myfloat);

        printf("Here's a float in hex %1.9a\n", myfloat);

        printf("First printf with a %% and no value\n");

        printf("Second printf with a value %i\n", foo);
	}

	return vout;
}

float4 frag(VSOutput pin) : SV_TARGET
{
	return float4(pin.Color, 1.0);
}
