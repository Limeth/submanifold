#version 450

#extension GL_ARB_separate_shader_objects: enable
#extension GL_ARB_shading_language_420pack: enable

// Tau is the masterconstant; Pi is inferior (Tau = 2 * Pi).
// See http://tauday.com/tau-manifesto
#define TAU    6.2831853071795864769252867665590057683943
#define SQRT_2 1.4142135623730950488016887242096980785696

layout(location = 0) in vec2 resolution;

layout(location = 0) out vec4 f_color;

vec3 get_coord_direction(in mat3 camera_direction, in float fov_rad) {
    vec2 rel = gl_FragCoord.xy - resolution / 2.0;
    float distance_from_screen_center =
        length(resolution) / (2.0 * tan(fov_rad / 2.0));
    vec3 direction = camera_direction[0] * distance_from_screen_center
                     + camera_direction[1] * -rel[0]
                     + camera_direction[2] * -rel[1];
    return normalize(direction);
}

vec4 intersect_sphere(in vec3 ray_origin, in vec3 ray_direction,
                      in vec3 sphere_center, in float radius) {
    vec3 rel = ray_origin - sphere_center;
    float a = dot(ray_direction, ray_direction);
    float b = 2.0 * dot(ray_direction, rel);
    float c = dot(rel, rel) - radius * radius;

    // Discriminant of a quadratic function
    float d = b * b - 4.0 * a * c;

    if(d < 0.0) {
        return vec4(0.0);
    }

    float sqrt_d = sqrt(d);
    float dist;
    float t = (-b - sqrt_d) / (2.0 * a);

    if(t > 0.0) {
        dist = t;
    } else {
        t = (-b + sqrt_d) / (2.0 * a);

        if(t > 0.0) {
            dist = t;
        } else {
            return vec4(0.0);
        }
    }

    vec3 intersection = ray_origin + ray_direction * dist;
    vec3 normal = intersection - sphere_center;

    return vec4(normal, 1.0);
}

vec4 trace(in vec3 ray_origin, in vec3 ray_direction) {
    return intersect_sphere(ray_origin, ray_direction, vec3(3.0, 0.0, 0.0), 1.0);
}

void main() {
    vec3 camera_location = vec3(0.0);
    mat3 camera_direction = mat3(
                                vec3(1.0, 0.0, 0.0),
                                vec3(0.0, 1.0, 0.0),
                                vec3(0.0, 0.0, 1.0)
                            );
    float fov_rad = radians(90.0);
    vec2 coord_normalized = 2.0 * gl_FragCoord.xy / resolution.xy - vec2(1.0);
    vec3 coord_direction = get_coord_direction(camera_direction,
                                               fov_rad);
    vec4 coord_color = trace(camera_location, coord_direction);
    f_color = mix(vec4(fract(coord_direction * 32.0), 1.0), coord_color, 0.90);
}
