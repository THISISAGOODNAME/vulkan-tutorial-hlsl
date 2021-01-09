#version 450
#extension GL_ARB_separate_shader_objects : enable
#extension GL_EXT_debug_printf : enable

layout(location = 0) in vec2 inPosition;
layout(location = 1) in vec3 inColor;

layout(location = 0) out vec3 fragColor;

void main() {
    gl_Position = vec4(inPosition, 0.0, 1.0);
    fragColor = inColor;

    // debugPrintfEXT
    if (gl_VertexIndex == 0)
    {
        float myfloat = 3.1415f;
        int foo = -135;

        debugPrintfEXT("Here are two float values %f, %f\n", 1.0, myfloat);

        debugPrintfEXT("Here's a smaller float value %1.2f\n", myfloat);

        debugPrintfEXT("Here's an integer %i with text before and after it\n", foo);

        foo = 256;
        debugPrintfEXT("Here's an integer in octal %o and hex 0x%x\n", foo, foo);

        foo = -135;
        debugPrintfEXT("%d is a negative integer\n", foo);

        vec4 floatvec = vec4(1.2f, 2.2f, 3.2f, 4.2f);
        debugPrintfEXT("Here's a vector of floats %1.2v4f\n", floatvec);

        debugPrintfEXT("Here's a float in sn %e\n", myfloat);

        debugPrintfEXT("Here's a float in sn %1.2e\n", myfloat);

        debugPrintfEXT("Here's a float in shortest %g\n", myfloat);

        debugPrintfEXT("Here's a float in hex %1.9a\n", myfloat);

        debugPrintfEXT("First printf with a %% and no value\n");

        debugPrintfEXT("Second printf with a value %i\n", foo);
    }
}