//
//  HomeMapViewController.swift
//  Maps
//
//  Created by Mohamed Ali on 29/08/2021.
//

import UIKit
import RxSwift
import RxCocoa
import DropDown

class HomeMapViewController: UIViewController {
    
    // MARK:- TODO:- Initialise IBOutlets here
    @IBOutlet weak var SearchTextField: UITextField!
    @IBOutlet weak var CatagoryTextField: UITextField!
    @IBOutlet weak var GoogleMapView: UIView!
    // ------------------------------------------------
    
    
    // MARK:- TODO:- Initialise new varibles.
    let homemapviewmodel = HomeMapViewModel()
    let disposebag = DisposeBag()
    let dropdown = DropDown()
    var picker: UIPickerView! = nil
    // ------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dropdown.hide()
        
        ConfigureTextField()
        SubscribeToSearchTextField()
        SubscribeToTextFieldEmpty()
        
        SetGoogleMapInit()
        
        GetNames()
        
        GetCatagory()
    }
    
    // MARK:- TODO:- This Method For check is SearchTextField is Empty or not to filter array and disable return button.
    func SubscribeToTextFieldEmpty() {
        
        homemapviewmodel.isSearchBehaviour.subscribe(onNext: { [weak self] isEmpty in
            
            guard let self = self else { return }
            
            if isEmpty {
                self.SearchTextField.enablesReturnKeyAutomatically = true
                self.homemapviewmodel.namesBehaviour.accept(self.homemapviewmodel.BackupBehaviour.value)
                self.ConfigureDropDown()
                self.dropdown.show()
            }
            else {
                self.SearchTextField.enablesReturnKeyAutomatically = false
                self.homemapviewmodel.FilterOperation()
                self.ConfigureDropDown()
            }
            
        }).disposed(by: disposebag)
        
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This method for configure the textfield.
    func ConfigureTextField() {
        CatagoryTextField.SetCornerRadious(paddingValue: 0, PlaceHolder: "Enter Catagory", Color: UIColor.darkGray)
        SearchTextField.SetCornerRadious(paddingValue: 20, PlaceHolder: "Enter Place you wanna search into it", Color: UIColor.darkGray)
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Binding TextField for his rxSwift Varible.
    func SubscribeToSearchTextField() {
        SearchTextField.rx.text.orEmpty.bind(to: homemapviewmodel.textFieldBehaviour).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- Set GoogleMaps Init with the portfouad location.
    func SetGoogleMapInit() {
        homemapviewmodel.SetGoogleMapsOperation(lati: 31.2563, long: 32.3123, view: GoogleMapView, zoom: 15, delegate: self)
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Adding DropDown To Search TextField.
    func ConfigureDropDown() {
        
        self.ConfigureDataSource()
        
        dropdown.anchorView = SearchTextField
        dropdown.bottomOffset = CGPoint(x: 0, y:(dropdown.anchorView?.plainView.bounds.height)!)
        dropdown.width = self.SearchTextField.frame.size.width
        DropDown.startListeningToKeyboard()
        
        
        // Action triggered on selection
        dropdown.selectionAction = { [weak self] (index: Int, item: String) in
            
            guard let self = self else { return }
            
            self.SearchTextField.text = item
            self.homemapviewmodel.PickedNameBehaviour.accept(item)
            self.homemapviewmodel.SearchPlaceOperation(View: self.GoogleMapView)
            self.SearchTextField.resignFirstResponder()
            self.dropdown.hide()
            
            print("Selected item: \(item) at index: \(index)")
            
        }
        
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Configure Datasource for DropDown Menu.
    func ConfigureDataSource() {
        var names = Array<String>()
        
        for i in self.homemapviewmodel.namesBehaviour.value {
            names.append(i.shopName)
        }
        
        self.dropdown.dataSource = names
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Getting Places From Firebase and Add to DropMenu.
    func GetNames() {
        homemapviewmodel.GetNamesOperation { result in
            if result {
                self.ConfigureDropDown()
                
            }
        }
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Full Catagory.
    func GetCatagory() {
        homemapviewmodel.FillCatagoryOperation()
    }
    // ------------------------------------------------
}

