//
//  metalTest.metal
//  MetalTest4
//
//  Created by 福山帆士 on 2020/07/24.
//  Copyright © 2020 福山帆士. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

// シェーダFile

// 頂点シェーダの出力となる構造体
struct ColorInOut
{
    float4 position [[ position ]]; // (x, y, z, w)
};

// constを入れたらerrorが消えた
// 頂点シェーダ(ここでは何もしない) 1. [[ buffer(0)]] = swiftからのBufferの内容  2, [[ vertex_id]] = 頂点のインデックス
vertex ColorInOut vertexShader(const device float4 *positions [[ buffer(0)]],
                               uint             vid     [[ vertex_id]])
{
    ColorInOut out;
    out.position = positions[vid];
    return out;
}


// フラグメントシェーダ(ピクセルに関する処理)
fragment float4 fragmentShader(ColorInOut in [[ stage_in ]])
{
    return float4(1, 0, 0, 1); // (r, g, b, a) 赤を描画
}


