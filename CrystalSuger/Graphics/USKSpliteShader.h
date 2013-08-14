//
//  SpliteShader.h
//  CrystalSuger
//
//  Created by 吉村 篤 on 2013/04/16.
//  Copyright (c) 2013年 吉村 篤. All rights reserved.
//

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
