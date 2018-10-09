//
//  UIColorExtension.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 5. 17..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class var defaultBlack: UIColor {
        return UIColor(red: 69.0/255.0, green: 69.0/255.0, blue: 69.0/255.0, alpha: 1.0)
    }
    
    class var inactive: UIColor {
        return UIColor(red: 196.0/255.0, green: 196.0/255.0, blue: 196.0/255.0, alpha: 1.0)
    }
    
    class var buttonClick: UIColor {
        return UIColor(red: 152.0/255.0, green: 152.0/255.0, blue: 152.0/255.0, alpha: 1.0)
    }
    
    class var buttonBackground: UIColor {
        return UIColor(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0)
    }
    
    class var disable: UIColor {
        return UIColor(red: 205.0/255.0, green: 205.0/255.0, blue: 205.0/255.0, alpha: 1.0)
    }
}
