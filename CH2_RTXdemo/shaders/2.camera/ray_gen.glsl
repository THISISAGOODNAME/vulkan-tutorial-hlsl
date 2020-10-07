#version 460
#extension GL_NV_ray_tracing : require
#extension GL_GOOGLE_include_directive : require

#include "../shared_with_shaders.h"

layout(set = 0, binding = 0) uniform accelerationStructureNV Scene;
layout(set = 0, binding = 1, rgba8) uniform image2D ResultImage;

layout(set = SWS_CAMDATA_SET,      binding = SWS_CAMDATA_BINDING, std140)     uniform AppData {
    UniformParams Params;
};

layout(location = 0) rayPayloadNV vec3 ResultColor;

vec3 CalcRayDir(vec2 screenUV, float aspect) {
    vec3 u = Params.camSide.xyz;
    vec3 v = Params.camUp.xyz;

    const float planeWidth = tan(Params.camNearFarFov.z * 0.5f);

    u *= (planeWidth * aspect);
    v *= planeWidth;

    const vec3 rayDir = normalize(Params.camDir.xyz + (u * screenUV.x) - (v * screenUV.y));
    return rayDir;
}

void main() {
    // const vec2 uv = vec2(gl_LaunchIDNV.xy) / vec2(gl_LaunchSizeNV.xy - 1);

    const vec2 curPixel = vec2(gl_LaunchIDNV.xy);
    const vec2 bottomRight = vec2(gl_LaunchSizeNV.xy - 1);

    const vec2 uv = (curPixel / bottomRight) * 2.0f - 1.0f;

    const float aspect = float(gl_LaunchSizeNV.x) / float(gl_LaunchSizeNV.y);

    // const vec3 origin = vec3(uv.x, 1.0f - uv.y, -1.0f);
    // const vec3 direction = vec3(0.0f, 0.0f, 1.0f);

    vec3 origin = Params.camPos.xyz;
    vec3 direction = CalcRayDir(uv, aspect);

    const uint rayFlags = gl_RayFlagsNoneNV;
    const uint cullMask = 0xFF;
    const uint sbtRecordOffset = 0;
    const uint sbtRecordStride = 0;
    const uint missIndex = 0;
    const float tmin = 0.0f;
    const float tmax = Params.camNearFarFov.y;
    const int payloadLocation = 0;

    traceNV(Scene,
             rayFlags,
             cullMask,
             sbtRecordOffset,
             sbtRecordStride,
             missIndex,
             origin,
             tmin,
             direction,
             tmax,
             payloadLocation);

    imageStore(ResultImage, ivec2(gl_LaunchIDNV.xy), vec4(ResultColor, 1.0f));
}
