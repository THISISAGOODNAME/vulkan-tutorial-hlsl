#version 460
#extension GL_EXT_ray_tracing : require
#extension GL_GOOGLE_include_directive : require

#include "../shared_with_shaders.h"

layout(location = SWS_LOC_PRIMARY_RAY) rayPayloadInEXT vec3 ResultColor;

void main() {
    ResultColor = vec3(0.412f, 0.796f, 1.0f);
}
