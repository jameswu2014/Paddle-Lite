//
//  PreProcessKernel.metal
//  paddle-mobile-demo
//
//  Created by liuRuiLong on 2018/7/20.
//  Copyright © 2018年 orange. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;


kernel void preprocess(
                       texture2d<float, access::read> inTexture [[texture(0)]],
                       texture2d<float, access::write> outTexture [[texture(1)]],
                       uint2 gid [[thread_position_in_grid]])
{
    if (gid.x >= outTexture.get_width() ||
        gid.y >= outTexture.get_height()) {
        return;
    }
    // Subtract mean values, scale by 0.017, convert to BGR.
    
    const auto means = float4(103.94f, 116.78f, 123.68f, 0.0f);
    const float4 inColor = (float4(inTexture.read(gid)) * 255.0f - means) * 0.017f;
    outTexture.write(float4(inColor.x, inColor.y, inColor.z, 0.0f), gid);
}
