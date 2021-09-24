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
    
    func createAlert (Title:String , Mess:String) {
        let alert = UIAlertController(title: Title , message:Mess
            , preferredStyle:UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok" ,style:UIAlertAction.Style.default,handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        self.present(alert,animated:true,completion: nil)
    }
    
}
