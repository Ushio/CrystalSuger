/*
 Copyright (c) 2013 ushio
 
 This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.
 
 Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
 
 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
 
 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
 
 3. This notice may not be removed or altered from any source distribution.
 */

#ifndef CrystalSuger_SpliteShader_h
#define CrystalSuger_SpliteShader_h

static NSString *const kSpliteVS = SHADER_STRING(
                                                 uniform mat4 u_transform;
                                                 
                                                 attribute vec4 a_position;
                                                 attribute vec2 a_texcoord;
                                                 
                                                 varying highp vec2 v_uv;
                                                 void main()
                                                 {
                                                     v_uv = a_texcoord;
                                                     gl_Position = u_transform * a_position;
                                                 }
                                                 );
static NSString *const kSpliteFS = SHADER_STRING(
                                                 precision highp float;
                                                 
                                                 uniform sampler2D u_image;
                                                 varying highp vec2 v_uv;
                                                 void main()
                                                 {
                                                     gl_FragColor = texture2D(u_image, v_uv);
                                                 }
                                                 );

#endif
