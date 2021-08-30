//
//  DirectionViewController.swift
//  Maps
//
//  Created by Mohamed Ali on 30/08/2021.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa
import DropDown
import CoreLocation

class DirectionViewController: UIViewController {
    
    // MARK:- TODO:- This Sektion For Initialise new IBOutlets.
    @IBOutlet weak var SearchTextField: UITextField!
    @IBOutlet weak var MapKit: MKMapView!
    
    // MARK:- TODO:- This Section For Adding Varibles Here.
    let directionviewmodel = DirectionViewModel()
    let homemapviewmodel = HomeMapViewModel()
    let dropdown = DropDown()
    let location = CLLocationManager()
    let disposebag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        ConfigureSearchTextField()
        BindSearchTextField()
        SubscribeToSearchTextFieldisEmpty()
        
        GetNames()
        
        ConfigureLocation()
    }
    
    
    // MARK:- TODO:- Configure TextField Shape with CornerRadious and the placeholder
    func ConfigureSearchTextField() {
        SearchTextField.SetCornerRadious(paddingValue: 25, PlaceHolder: "Enter Place you want to go it", Color: UIColor.black)
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Realte the TextField To His RxSwift.
    func BindSearchTextField() {
        SearchTextField.rx.text.orEmpty.bind(to: homemapviewmodel.textFieldBehaviour).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Check if Textfield is Empty or not.
    func SubscribeToSearchTextFieldisEmpty() {
        
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
            
            print("Selected item: \(item) at index: \(index)")
            self.SearchTextField.text = item
            self.SearchTextField.resignFirstResponder()
            
            self.directionviewmodel.PickedShopNamed.accept(item)
//            self.directionviewmodel.AddAnotationOperation(mapview: self.MapKit)
            
            self.location.delegate = self
            self.location.desiredAccuracy = kCLLocationAccuracyBest
            self.location.requestWhenInUseAuthorization()
            self.location.startUpdatingLocation()
            
            self.dropdown.hide()
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
    
    
    // MARK:- TODO:- This Method For Getting Names from Firebase.
    func GetNames() {
        
        homemapviewmodel.GetNamesOperation { [weak self] response in
            
            guard let self = self else { return }
            
            if response {
                self.ConfigureDropDown()
            }
        }
        
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Configure The Location.
    func ConfigureLocation() {
         location.delegate = self
         location.desiredAccuracy = kCLLocationAccuracyHundredMeters
         location.requestWhenInUseAuthorization()
         location.startUpdatingLocation()
    }
    // ------------------------------------------------
}
