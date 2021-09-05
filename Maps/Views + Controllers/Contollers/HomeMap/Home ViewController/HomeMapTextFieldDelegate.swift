//
//  HomeMapTextFieldDelegate.swift
//  Maps
//
//  Created by Mohamed Ali on 29/08/2021.
//

import UIKit
import GoogleMaps
import RxSwift
import RxCocoa

extension HomeMapViewController: UITextFieldDelegate {
    
    // MARK:- TODO:- This Method For Programm Return button to search place in the map
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == "" && textField.tag == 1 {
            self.view.endEditing(true)
        }
        else if textField.text != "" && textField.tag == 1 {
            self.view.endEditing(true)
            homemapviewmodel.SearchInDatabaseAndShowOperation(view: GoogleMapView)
            dropdown.hide()
        }
        return true
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- Show Menu when start Editing.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            dropdown.show()
        }
        else {
            dropdown.hide()
            addDoneButtonOnKeyboard(textField: CatagoryTextField)
            CatagoryTextField.inputView = loadPicker()
        }
        
    }
    
    
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
        self.homemapviewmodel.CatagoryArrBehaviour.bind(to: picker.rx.itemTitles) { _, item in
                return "\(item)"
            }
            .disposed(by: disposebag)
        
        // Bind Selected Item.
        Observable
            .zip(picker.rx.itemSelected, picker.rx.modelSelected(String.self))
            .bind { [weak self] selectedIndex, branch in

                    guard let self = self else { return }
                        
                self.homemapviewmodel.PickedCatagoryBehaviour.accept(branch.first!)
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
        print(homemapviewmodel.PickedCatagoryBehaviour.value)
        
        // Load All Places With This Catagory.
        CatagoryTextField.text = homemapviewmodel.PickedCatagoryBehaviour.value
        
        if homemapviewmodel.PickedCatagoryBehaviour.value == "All" {
            homemapviewmodel.ShowAllLocationOperation(view: self.GoogleMapView, long: 32.3123, latit: 31.2563, zoom: 13)
        }
        else {
            homemapviewmodel.FilterAndShowPlacesOperation(view: GoogleMapView)
            self.ConfigureDataSource()
        }
        
        
        // Dismiss Keypad after Complete.
        CatagoryTextField.resignFirstResponder()
        
    }
    // ------------------------------------------------
    
}

extension HomeMapViewController: GMSMapViewDelegate { }
