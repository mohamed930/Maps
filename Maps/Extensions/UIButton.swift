//
//  UIButton.swift
//  Maps
//
//  Created by Mohamed Ali on 30/08/2021.
//

import UIKit

extension UIButton {
    
    func MakeCornerRadious(BackGroundColour: String, BorderColour: String) {
        self.layer.cornerRadius = 23
        self.layer.masksToBounds = true
        self.layer.backgroundColor = UIColor().hexStringToUIColor(hex: BackGroundColour).cgColor
        
        self.layer.borderColor = UIColor().hexStringToUIColor(hex: BorderColour).cgColor
        self.layer.borderWidth = 1
    }
}
