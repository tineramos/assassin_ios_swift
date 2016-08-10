//
//  LightSaberView.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 10/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import UIKit
import AVFoundation

class LightSaberView: UIView {

    let captureSession = AVCaptureSession()
    
    var captureDevice: AVCaptureDevice?
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
