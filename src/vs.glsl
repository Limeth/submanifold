#version 450

#extension GL_ARB_separate_shader_objects: enable
#extension GL_ARB_shading_language_420pack: enable

layout(set = 0, binding = 0) uniform Data {
    vec2 resolution;
} uniforms;

layout(location = 0) in vec2 position;

layout(location = 0) out vec2 resolution;

void main() {
    gl_Position = vec4(position.xy, 0.0, 1.0);
    resolution = uniforms.resolution;
}
