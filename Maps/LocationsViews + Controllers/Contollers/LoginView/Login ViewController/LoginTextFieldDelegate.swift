//
//  LoginTextFieldDelegate.swift
//  Maps
//
//  Created by Mohamed Ali on 24/09/2021.
//

import UIKit

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            passwordTextField.becomeFirstResponder()
        }
        else {
            self.view.endEditing(true)
            
            // Call Method Login
        }
        return true
    }
    
}
