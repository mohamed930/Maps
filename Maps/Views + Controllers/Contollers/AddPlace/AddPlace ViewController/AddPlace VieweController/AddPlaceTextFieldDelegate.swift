//
//  AddPlaceTextFieldDelegate.swift
//  Maps
//
//  Created by Mohamed Ali on 30/08/2021.
//

import UIKit

extension AddPlaceViewController: UITextFieldDelegate {
    
    // MARK:- TODO:- this method for show label and hide based on text.
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if textField.tag == 1 {
            if ShopNameTextField.hasText {
                self.ShowLabelWithAnimation(LabelName: ShopNameLabel)
            }
            else {
                self.HideLabelWithAnimation(LabelName: ShopNameLabel)
            }
            
            Line1.layer.backgroundColor = UIColor().hexStringToUIColor(hex: buttonBorderColour).cgColor
            Line2.layer.backgroundColor = UIColor().hexStringToUIColor(hex: "#434343").cgColor
            
        }
        else {
            if ShopDetailsTextField.hasText {
                self.ShowLabelWithAnimation(LabelName: ShopDetailsLabel)
            }
            else {
                self.HideLabelWithAnimation(LabelName: ShopDetailsLabel)
            }
            
            Line2.layer.backgroundColor = UIColor().hexStringToUIColor(hex: buttonBorderColour).cgColor
            Line1.layer.backgroundColor = UIColor().hexStringToUIColor(hex: "#434343").cgColor
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag == 1 {
            // for name go to details
            self.ShopDetailsTextField.becomeFirstResponder()
        }
        else {
            // for shop Details dismiss keypad and make login operation
            self.view.endEditing(true)
            Line2.layer.backgroundColor = UIColor().hexStringToUIColor(hex: "#434343").cgColor
        }
        
        return true
        
    }
    
}
