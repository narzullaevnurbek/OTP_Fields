//
//  Extensions.swift
//  OTP
//
//  Created by Narzullaev Nurbek on 28/11/23.
//

import UIKit

extension UIFont {
    class func setFont(forTextStyle style: UIFont.TextStyle, weight: Weight) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: style)
        let descriptor = preferredFont(forTextStyle: style).fontDescriptor
        var dynamicSize = descriptor.pointSize
        
        // there you can use other custom fonts by this way:
        // fontToScale = UIFont(name: "Lexend-Light", size: dynamicSize)
        var fontToScale = UIFont.systemFont(ofSize: dynamicSize, weight: weight)
        return metrics.scaledFont(for: fontToScale)
    }
}

extension UITextField {
    func disabled() {
        self.isUserInteractionEnabled = false
    }
    
    func enabled() {
        self.isUserInteractionEnabled = true
    }
}
