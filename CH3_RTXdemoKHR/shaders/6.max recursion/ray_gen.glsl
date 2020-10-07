#version 460
#extension GL_EXT_ray_tracing : require
#extension GL_GOOGLE_include_directive : require

#include "../shared_with_shaders.h"

layout(set = SWS_SCENE_AS_SET,     binding = SWS_SCENE_AS_BINDING)            uniform accelerationStructureEXT Scene;
layout(set = SWS_RESULT_IMAGE_SET, binding = SWS_RESULT_IMAGE_BINDING, rgba8) uniform image2D ResultImage;

layout(set = SWS_CAMDATA_SET,      binding = SWS_CAMDATA_BINDING, std140)     uniform AppData {
    UniformParams Params;
};

layout(location = SWS_LOC_PRIMARY_RAY) rayPayloadEXT RayPayload PrimaryRay;
layout(location = SWS_LOC_SHADOW_RAY)  rayPayloadEXT ShadowRayPayload ShadowRay;

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
    const vec2 curPixel = vec2(gl_LaunchIDEXT.xy);
    const vec2 bottomRight = vec2(gl_LaunchSizeEXT.xy - 1);

    const vec2 uv = (curPixel / bottomRight) * 2.0f - 1.0f;

    const float aspect = float(gl_LaunchSizeEXT.x) / float(gl_LaunchSizeEXT.y);

    // const vec3 origin = vec3(uv.x, 1.0f - uv.y, -1.0f);
    // const vec3 direction = vec3(0.0f, 0.0f, 1.0f);

    vec3 origin = Params.camPos.xyz;
    vec3 direction = CalcRayDir(uv, aspect);

    const uint rayFlags = gl_RayFlagsNoneEXT;
    const uint cullMask = 0xFF;
    const uint sbtRecordOffset = 0;
    const uint sbtRecordStride = 0;
    const uint missIndex = 0;
    const float tmin = 0.0f;
    const float tmax = Params.camNearFarFov.y;

    vec3 finalColor = vec3(0.0f);

    for (int i = 0; i < SWS_MAX_RECURSION; ++i) {
        traceRayEXT(Scene,
                    rayFlags,
                    cullMask,
                    sbtRecordOffset,
                    sbtRecordStride,
                    missIndex,
                    origin,
                    tmin,
                    direction,
                    tmax,
                    SWS_LOC_PRIMARY_RAY);


        const vec3 hitColor = PrimaryRay.colorAndDist.rgb;
        const float hitDistance = PrimaryRay.colorAndDist.w;

        // if hit background - quit
        if (hitDistance < 0.0f) {
            finalColor += hitColor;
            break;
        } else {
            const vec3 hitNormal = PrimaryRay.normalAndObjId.xyz;
            const float objectId = PrimaryRay.normalAndObjId.w;

            const vec3 hitPos = origin + direction * hitDistance;

            if (objectId == OBJECT_ID_TEAPOT) {
                // our teapot is mirror, so reflect and continue

                origin = hitPos + hitNormal * 0.001f;
                direction = reflect(direction, hitNormal);
            } else {
                // we hit diffuse primitive - simple lambertian

                const vec3 toLight = normalize(Params.sunPosAndAmbient.xyz);
                const vec3 shadowRayOrigin = hitPos + hitNormal * 0.01f;
                const uint shadowRayFlags = gl_RayFlagsOpaqueEXT | gl_RayFlagsTerminateOnFirstHitEXT;
                const uint shadowRecordOffset = 1;
                const uint shadowMissIndex = 1;

                traceRayEXT(Scene,
                            shadowRayFlags,
                            cullMask,
                            shadowRecordOffset,
                            sbtRecordStride,
                            shadowMissIndex,
                            shadowRayOrigin,
                            tmin,
                            toLight,
                            tmax,
                            SWS_LOC_SHADOW_RAY);

                const float lighting = (ShadowRay.distance > 0.0f) ? Params.sunPosAndAmbient.w : max(Params.sunPosAndAmbient.w, dot(hitNormal, toLight));

                finalColor += hitColor * lighting;

                break;
            }
        }
    }

    imageStore(ResultImage, ivec2(gl_LaunchIDEXT.xy), vec4(LinearToSrgb(finalColor), 1.0f));
}
