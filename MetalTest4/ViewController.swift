//
//  ViewController.swift
//  MetalTest4
//
//  Created by 福山帆士 on 2020/07/24.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import MetalKit

class ViewController: UIViewController {
    
    private let device = MTLCreateSystemDefaultDevice()! // GPU
    
    private var commandQuere: MTLCommandQueue!
    
    // シェーダに渡すデータ(Float配列(x, y, z, w) )軸域 = -1 ~ 1
    private let vertexData: [Float] = [
        -1, -1, 0, 1,
        1, -1, 0, 1,
        -1, 1, 0, 1,
        1, 1, 0, 1
    ]
    
    private var vertexBuffer: MTLBuffer! // シェーダに渡すBufferを保持
    
    private var renderPipeline: MTLRenderPipelineState! // パイプライン(レンダリングの一連の処理)
    
    private let renderPassDescriptor = MTLRenderPassDescriptor() // レンダリング先のtextureの設定
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let myMtkView = MTKView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), device: device)
        
        view.addSubview(myMtkView)
        
        myMtkView.delegate = self
        
        commandQuere = device.makeCommandQueue()!
        
        
        // vertexBufferにデータ(シェーダに渡す)を格納
        let size = vertexData.count * MemoryLayout<Float>.size
        
        vertexBuffer = device.makeBuffer(bytes: vertexData, length: size)
        
        
        
        
        guard let library = device.makeDefaultLibrary() else { fatalError() } // Metalライブラリ
        
        let descriptor = MTLRenderPipelineDescriptor() // パイプラインの設定を記載するクラス(ディスクリプター)
        
        // ディスクリプターにシェーダ関数をセット
        descriptor.vertexFunction = library.makeFunction(name: "vertexShader")
        descriptor.fragmentFunction = library.makeFunction(name: "fragmentShader")
        
        // ピクセルフォーマット
        descriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        // パイプラインを作成する
        renderPipeline = try! device.makeRenderPipelineState(descriptor: descriptor)
        
        
        
        
        
        myMtkView.enableSetNeedsDisplay = true
        
        myMtkView.setNeedsLayout() // viewの更新依頼(draw: inが呼ばれる)
        
        
    }


}

extension ViewController: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable else {
            fatalError()
        }
        
        guard let commandBuffer = commandQuere.makeCommandBuffer() else { // Buffer
            fatalError()
        }
        
        
        
        //  ************************* Metaltest1とちがう
        
        // ここでtextureを設定
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        
        // エンコード
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        
        guard let renderPipeline = renderPipeline else { fatalError() }
        
        // エンコードの設定
        renderEncoder.setRenderPipelineState(renderPipeline)
        
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        // triangleStrip(四角形に描画)
        renderEncoder.drawPrimitives(type: .triangleStrip,
                                      vertexStart: 0,
                                      vertexCount: 4)
        
        
        // *******************************
        
        
        
        renderEncoder.endEncoding() // エンコード終了
        
        commandBuffer.present(drawable) // bufferに追加
        
        commandBuffer.commit() // エンキュー
        
        commandBuffer.waitUntilCompleted()
        
        
        
        
    }
    
    
}

