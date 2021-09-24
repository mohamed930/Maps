//
//  DirectionTextFieldDelegate.swift
//  Maps
//
//  Created by Mohamed Ali on 30/08/2021.
//

import UIKit

extension DirectionViewController: UITextFieldDelegate {
    
    // MARK:- TODO:- This Method For Programm Return button to search place in the map
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            self.view.endEditing(true)
        }
        else {
            self.view.endEditing(true)
            dropdown.hide()
        }
        return true
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- Show Menu when start Editing.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        dropdown.show()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        dropdown.show()
        return true
    }
    // ------------------------------------------------
    
}
