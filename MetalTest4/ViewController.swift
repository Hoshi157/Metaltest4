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
    
    private let vertexData: [Float] = [
        -1, -1, 0, 1,
        1, -1, 0, 1,
        -1, 1, 0, 1,
        1, 1, 0, 1
    ]
    
    private var vertexBuffer: MTLBuffer!
    
    private var renderPipeline: MTLRenderPipelineState!
    
    private let renderPassDescriptor = MTLRenderPassDescriptor()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let myMtkView = MTKView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), device: device)
        
        view.addSubview(myMtkView)
        
        myMtkView.delegate = self
        
        commandQuere = device.makeCommandQueue()!
        
        
        
        
        
        
        let size = vertexData.count * MemoryLayout<Float>.size
        
        vertexBuffer = device.makeBuffer(bytes: vertexData, length: size)
        
        
        
        guard let library = device.makeDefaultLibrary() else { fatalError() }
        
        let descriptor = MTLRenderPipelineDescriptor()
        
        descriptor.vertexFunction = library.makeFunction(name: "vertexShader")
        descriptor.fragmentFunction = library.makeFunction(name: "fragmentShader")
        
        descriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
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
        
        
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        
        
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        
        guard let renderPipeline = renderPipeline else { fatalError() }
        
        renderEncoder.setRenderPipelineState(renderPipeline)
        
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        renderEncoder.drawPrimitives(type: .triangleStrip,
                                      vertexStart: 0,
                                      vertexCount: 4)
        
        
        // *******************************
        
        
        
        renderEncoder.endEncoding() // エンコード
        
        commandBuffer.present(drawable) // bufferに追加
        
        commandBuffer.commit() // エンキュー
        
        commandBuffer.waitUntilCompleted()
        
        
        
        
    }
    
    
}

