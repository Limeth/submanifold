#version 450

#extension GL_ARB_separate_shader_objects: enable
#extension GL_ARB_shading_language_420pack: enable

layout(location = 0) in vec2 resolution;

layout(location = 0) out vec4 f_color;

void main() {
    vec2 pixel_normalized = gl_FragCoord.xy / resolution.xy;
    f_color = vec4(pixel_normalized, 0.0, 1.0);
}
