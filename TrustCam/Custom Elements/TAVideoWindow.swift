//
//  TAVideoWindow.swift
//  TrustCam
//
//  Created by Caner Ates on 2019/10/28.
//  Copyright © 2019 Caner Ates All rights reserved.
//

import UIKit
import QuartzCore

class TAVideoWindow: UIControl {
    
    override class var layerClass: AnyClass {
        return CAEAGLLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
        let eaglLayer = layer as? CAEAGLLayer
        eaglLayer?.isOpaque = true
        
        eaglLayer?.drawableProperties = [kEAGLDrawablePropertyRetainedBacking : 0 , kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8]
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
}



