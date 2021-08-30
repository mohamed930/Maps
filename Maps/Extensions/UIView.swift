//
//  UIView.swift
//  Maps
//
//  Created by Mohamed Ali on 30/08/2021.
//

import UIKit

extension UIView {
    
    func SetCornerRadious(BackgroundColor: String, BorderColor: String) {
        
        // Add Radious Corner and add background Colour
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.masksToBounds = true
        self.layer.backgroundColor = UIColor().hexStringToUIColor(hex: BackgroundColor).cgColor
        
        // Add Border width and Border Colour
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor().hexStringToUIColor(hex: BorderColor).cgColor
        
    }
    
}
