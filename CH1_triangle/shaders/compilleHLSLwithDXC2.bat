dxc.exe -spirv -T vs_6_0 -E vert hlsl/shader.hlsl -Fo vert.spv
dxc.exe -spirv -T ps_6_0 -E frag hlsl/shader.hlsl -Fo frag.spv
pause