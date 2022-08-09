/*
Codes based on Vulakn tutorial
https://vulkan-tutorial.com/

Youtube : Medist
Github : Medist-1

edited 2022 / 8 / 9
*/

#version 450

layout(binding = 0) uniform UniformBufferObject {
    mat4 model;
    mat4 view;
    mat4 proj;
    mat4 distort;
    float yoffset;
} ubo;

layout(location = 0) in vec3 inPosition;
layout(location = 1) in vec3 inColor;
layout(location = 2) in vec2 inTexCoord;

layout(location = 0) out vec3 fragColor;
layout(location = 1) out vec2 fragTexCoord;

void main() {

    vec3 inPosition2 = inPosition;
    inPosition2[1] -= ubo.yoffset;

    gl_Position = ubo.proj * ubo.view * ubo.model * vec4(inPosition2, 1.0f);

    float expand_ratio_x = 0.0f;
    float expand_ratio_y = 0.0f;

    float x_ratio =  gl_Position[0]/gl_Position[3];
    float y_ratio = -gl_Position[1]/gl_Position[3];

    float flag = x_ratio * ubo.distort[2][0] + y_ratio * ubo.distort[2][1] + ubo.distort[2][2];
    float x_ratio_after =  (x_ratio * ubo.distort[0][0] + y_ratio * ubo.distort[0][1])/flag;
    float y_ratio_after =  (x_ratio * ubo.distort[1][0] + y_ratio * ubo.distort[1][1])/flag;

    expand_ratio_x = x_ratio_after - x_ratio;
    expand_ratio_y = -(y_ratio_after - y_ratio);

    gl_Position[0] = gl_Position[0] +  (expand_ratio_x) * gl_Position[3];
    gl_Position[1] = gl_Position[1] +  (expand_ratio_y) * gl_Position[3];

    fragColor = inColor;
    fragTexCoord = inTexCoord;

}