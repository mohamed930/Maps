//
//  UIViewController.swift
//  Maps
//
//  Created by Mohamed Ali on 30/08/2021.
//

import UIKit

extension UIViewController {
    
    func ShowLabelWithAnimation (LabelName: UILabel) {
        UIView.animate(withDuration: 0.6) {
            LabelName.isHidden = false
            self.view.layoutIfNeeded()
        }
    }
    
    func HideLabelWithAnimation (LabelName: UILabel) {
        UIView.animate(withDuration: 0.6) {
            LabelName.isHidden = true
            self.view.layoutIfNeeded()
        }
    }
    
}
