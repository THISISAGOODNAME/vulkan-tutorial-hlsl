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

		// CHECK: {{%\d+}} = OpExtInst %void [[set]] 1 [[format1]]
  		printf(first);
		// CHECK: {{%\d+}} = OpExtInst %void [[set]] 1 [[format2]]
  		printf(second);
		// CHECK: {{%\d+}} = OpExtInst %void [[set]] 1 [[format3]]
  		printf("please print this message.\n");
		// CHECK: {{%\d+}} = OpExtInst %void [[set]] 1 [[format4]] %uint_1 %uint_2 %float_1_5
  		printf("Variables are: %d %d %.2f\n", 1u, 2u, 1.5f);
		// CHECK: {{%\d+}} = OpExtInst %void [[set]] 1 [[format5]] %int_1 %int_2 %int_3
  		printf("Integers are: %d %d %d\n", 1, 2, 3);
		// CHECK: {{%\d+}} = OpExtInst %void [[set]] 1 [[format6]] %int_1 %int_2 %int_3 %int_4 %int_5 %int_6 %int_7 %int_8 %int_9 %int_10
  		printf("More: %d %d %d %d %d %d %d %d %d %d\n", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
	}

	return vout;
}

float4 frag(VSOutput pin) : SV_TARGET
{
	return float4(pin.Color, 1.0);
}
