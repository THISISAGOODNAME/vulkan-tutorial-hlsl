dxc.exe -spirv -T vs_6_0 -E main hlsl/shader.vert -Fo vert.spv
dxc.exe -spirv -T ps_6_0 -E main hlsl/shader.frag -Fo frag.spv
pause