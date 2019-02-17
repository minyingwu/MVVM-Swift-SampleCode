//
//  UIImage+Effect.swift
//  BookMyMovie
//
//  Created by Victor on 2019/2/14.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

extension UIImageView {
    
    var rounded: UIImageView {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
        return self
    }
    
    var blurred: UIImageView {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
        return self
    }
    
    func blur(with blurRadius: CGFloat) -> UIImage? {
        guard let blur = CIFilter(name: "CIGaussianBlur") else { return nil }
        
        blur.setValue(CIImage(image: self.image!), forKey: kCIInputImageKey)
        blur.setValue(blurRadius, forKey: kCIInputRadiusKey)
        
        let ciContext  = CIContext(options: nil)
        let result = blur.value(forKey: kCIOutputImageKey) as! CIImage?
        
        let boundingRect = CGRect(x: 0,
                                  y: 0,
                                  width: self.frame.width,
                                  height: self.frame.height)
        
        let cgImage = ciContext.createCGImage(result!, from: boundingRect)
        
        return UIImage(cgImage: cgImage!)
    }
}
