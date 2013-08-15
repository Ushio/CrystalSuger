#pragma once

typedef struct{
    GLKVector2 position;
    GLKVector2 texcoord;
}SpliteVertex;

static const SpliteVertex spliteVertices[] =
{
    {{-1.0f,  1.0f}, {0.0f, 0.0f}},
    {{-1.0f, -1.0f}, {0.0f, 1.0f}},
    {{ 1.0f, -1.0f}, {1.0f, 1.0f}},
    {{ 1.0f,  1.0f}, {1.0f, 0.0f}},
};
