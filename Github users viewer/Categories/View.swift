//
//  View.swift
//  Github users viewer
//
//  Created by Vitaliy Bal on 4/10/18.
//  Copyright © 2018 VitaliySoft. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static func RGB(_ r: Int, _ g:Int,_ b:Int,_ a: Float = 1 ) -> UIColor {
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a))
    }
}

extension UIView {
    
    var width: CGFloat {
        get { return frame.size.width }
        set {
            if self.width != newValue {
                var frame: CGRect = self.frame
                frame.size.width = newValue
                self.frame = frame
            }
        }
    }
    
    var height: CGFloat {
        get { return frame.size.height }
        set {
            if self.height != newValue {
                var frame: CGRect = self.frame
                frame.size.height = newValue
                self.frame = frame
            }
        }
    }
    
    
    var left: CGFloat {
        get { return frame.origin.x }
        set {
            if self.left != newValue {
                var frame: CGRect = self.frame
                frame.origin.x = newValue
                self.frame = frame
            }
        }
    }
    
    var top: CGFloat {
        get { return frame.origin.y }
        set {
            if self.top != newValue {
                var frame: CGRect = self.frame
                frame.origin.y = newValue
                self.frame = frame
            }
        }
    }
    
    
    var right: CGFloat {
        get { return self.left + self.width }
        set {
            if self.right != newValue {
                var frame: CGRect = self.frame
                frame.origin.x = newValue - self.width;
                self.frame = frame
            }
        }
    }
    
    var bottom: CGFloat {
        get { return self.top + self.height }
        set {
            if self.bottom != newValue {
                var frame: CGRect = self.frame
                frame.origin.y = newValue - self.height;
                self.frame = frame
            }
        }
    }
    
    
    var size: CGSize {
        get { return frame.size }
        set {
            frame.size = newValue
        }
    }
    
}
