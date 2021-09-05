//
//  AddPlaceTextFieldDelegate.swift
//  Maps
//
//  Created by Mohamed Ali on 30/08/2021.
//

import UIKit
import RxSwift
import RxCocoa

extension AddPlaceViewController: UITextFieldDelegate {
    
    // MARK:- TODO:- this method for show label and hide based on text.
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if textField.tag == 1 {
            ConfigureTextFieldActive(textField: ShopNameTextField, ActiveLine: Line1, NonActiveLine: [Line2,Line3], Label: ShopNameLabel)
        }
        else if textField.tag == 2 {
            ConfigureTextFieldActive(textField: ShopDetailsTextField, ActiveLine: Line2, NonActiveLine: [Line1,Line3], Label: ShopDetailsLabel)
        }
        else if textField.tag == 3 {
            ConfigureTextFieldActive(textField: CatagoryTextField, ActiveLine: Line3, NonActiveLine: [Line1,Line2], Label: CatagoryLabel)
        }
        
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Return Button in KeyPad.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag == 1 {
            // for name go to details
            self.ShopDetailsTextField.becomeFirstResponder()
        }
        else if textField.tag == 2 {
            self.CatagoryTextField.becomeFirstResponder()
        }
        
        return true
        
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This 
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.tag == 3 {
            addDoneButtonOnKeyboard(textField: CatagoryTextField)
            CatagoryTextField.inputView = loadPicker()
        }
    }
    
    
    // MARK:- TODO:- This Method For Configure action when textField Activted
    private func ConfigureTextFieldActive(textField: UITextField, ActiveLine: UIView , NonActiveLine: [UIView] , Label: UILabel) {
        
        if textField.hasText {
            self.ShowLabelWithAnimation(LabelName: Label)
        }
        else {
            self.HideLabelWithAnimation(LabelName: Label)
        }
        
        ActiveLine.layer.backgroundColor = UIColor().hexStringToUIColor(hex: buttonBorderColour).cgColor
        NonActiveLine[0].layer.backgroundColor = UIColor().hexStringToUIColor(hex: "#434343").cgColor
        NonActiveLine[1].layer.backgroundColor = UIColor().hexStringToUIColor(hex: "#434343").cgColor
        
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Convert TextField To PickerView.
    private func loadPicker() -> UIPickerView {
        
        // Load picker and return from here.
        picker = UIPickerView()
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKeyPath: "textColor")
        
        BindPickerViewToRxSwift()

        return picker
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Binding PickerView to his RxSwift.
    func BindPickerViewToRxSwift() {
        
        // Bind DataSource.
        addplaceviewmodel.CatagoryBehaviour.bind(to: picker.rx.itemTitles) { _, item in
                return "\(item)"
            }
            .disposed(by: disposebag)
        
        // Bind Selected Item.
        Observable
            .zip(picker.rx.itemSelected, picker.rx.modelSelected(String.self))
            .bind { [weak self] selectedIndex, branch in

                    guard let self = self else { return }
                        
                self.addplaceviewmodel.PickedCatagoryBehaviour.accept(branch.first!)
            }.disposed(by: disposebag)
        
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Adding done Button to Keypad.
    private func addDoneButtonOnKeyboard(textField: UITextField)
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textField.frame.size.width, height: 50))
        doneToolbar.barStyle = UIBarStyle.default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonAction))

        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)

        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()

        textField.inputAccessoryView = doneToolbar
        textField.inputAccessoryView = doneToolbar

    }

    @objc func doneButtonAction() {
        print(addplaceviewmodel.PickedCatagoryBehaviour.value)
        
        // Load All Places With This Catagory.
        CatagoryTextField.text = addplaceviewmodel.PickedCatagoryBehaviour.value
        
        // Dismiss Keypad after Complete.
        CatagoryTextField.resignFirstResponder()
        Line3.layer.backgroundColor = UIColor().hexStringToUIColor(hex: "#434343").cgColor
        
    }
    // ------------------------------------------------
}
