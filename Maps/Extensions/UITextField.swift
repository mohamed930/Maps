//
//  UITextField.swift
//  Maps
//
//  Created by Mohamed Ali on 29/08/2021.
//

import UIKit

extension UITextField {
    
    func SetCornerRadious(paddingValue: Int,PlaceHolder: String, Color: UIColor) {
        
        // Make Frame corner Radious
        self.layer.cornerRadius = 25
        self.layer.masksToBounds = true
        
        // Add Border Brown Color and Add To Width
        self.layer.borderColor = UIColor.brown.cgColor
        self.layer.borderWidth = 2
        
        // Add Left Padding to textField
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: paddingValue, height: 20))
        self.leftView = paddingView
        self.leftViewMode = .always
        
        // Add Custom PlaceHolder To TextField
        self.attributedPlaceholder = NSAttributedString(string: PlaceHolder,
                attributes: [NSAttributedString.Key.foregroundColor: Color])
        
    }
    
}
