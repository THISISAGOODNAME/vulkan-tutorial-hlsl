:: raygen shaders
glslangValidator -V -S rgen ray_gen.glsl -o ray_gen.spv

:: closest-hit shaders
glslangValidator -V -S rchit ray_chit.glsl -o ray_chit.spv
glslangValidator -V -S rchit shadow_ray_chit.glsl -o shadow_ray_chit.spv

:: miss shaders
glslangValidator -V -S rmiss ray_miss.glsl -o ray_miss.spv
glslangValidator -V -S rmiss shadow_ray_miss.glsl -o shadow_ray_miss.spv

pause