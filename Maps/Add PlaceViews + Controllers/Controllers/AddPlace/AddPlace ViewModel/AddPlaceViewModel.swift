//
//  AddPlaceViewModel.swift
//  Maps
//
//  Created by Mohamed Ali on 30/08/2021.
//

import Foundation
import RxCocoa
import RxSwift
import GoogleMaps

class AddPlaceViewModel {
    
    var ShopNameBehaviour = BehaviorRelay<String>(value: "")
    var ShopDetailsBehaviour = BehaviorRelay<String>(value: "")
    var ShopIconBehaviour = BehaviorRelay<UIImage?>(value: nil)
    var longBehaviour = BehaviorRelay<Double>(value: 0.0)
    var latiBehaviour = BehaviorRelay<Double>(value: 0.0)
    
    var CatagoryBehaviour = BehaviorRelay<[String]>(value: [])
    var PickedCatagoryBehaviour = BehaviorRelay<String>(value: "")
    
    // MARK:- TODO:- Initialise map varibles.
    let apiKey = "AIzaSyBBj9ciIrTveza-147dJ81OcCGvsSYrPfo"
    var mapView:GMSMapView?
    var camera:GMSCameraPosition?
    // ------------------------------------------------
    
    
    // MARK:- TODO:- Make Validation Oberval here.
    var isShopNameBehaviour : Observable<Bool> {
        return ShopNameBehaviour.asObservable().map { shopname -> Bool in
            let isnameEmpty = shopname.trimmingCharacters(in: .whitespaces).isEmpty
            
            return isnameEmpty
        }
    }
    
    var isShopDetailsBehaviour : Observable<Bool> {
        return ShopDetailsBehaviour.asObservable().map { shopdetails -> Bool in
            let isdetailsEmpty = shopdetails.trimmingCharacters(in: .whitespaces).isEmpty
            
            return isdetailsEmpty
        }
    }
    
    var isNextButtonEnabled: Observable<Bool> {
        return Observable.combineLatest(isShopNameBehaviour,isShopDetailsBehaviour) {
            emailEmpty , passwordEmpty in
            let loginValid = !emailEmpty && !passwordEmpty
            
            return loginValid
        }
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- Set Map API Key
    private func setApiKEY() {
        GMSServices.provideAPIKey(apiKey)
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Methdo For Show Map when Load Page.
    func SetGoogleMapsOperation(lati: Double,long: Double ,view: UIView,zoom: Float, delegate: GMSMapViewDelegate) {
        
        setApiKEY()
                
        camera = GMSCameraPosition.camera(withLatitude: lati, longitude: long , zoom: zoom)
        
        mapView = GMSMapView.map(withFrame: view.frame, camera: camera!)
        mapView?.delegate = delegate
        
        mapView!.frame = view.bounds
        mapView!.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        view.addSubview(mapView!)
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Fill Catagory Array.
    func LoadCatagoryOperation() {
        CatagoryBehaviour.accept(CatagoryArr)
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Draw Annotation in Google Maps.
    private func CreateAnnotation (view: UIView,long: Double, latit: Double,Title: String, Des: String,icon: UIImage ,zoom: Float) {
            
        setApiKEY()
        
        // Creates a marker in the center of the map.
        camera = GMSCameraPosition.camera(withLatitude: latit, longitude: long, zoom: zoom)
        mapView = GMSMapView.map(withFrame: view.frame, camera: camera!)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latit, longitude: long)
        marker.title = Title
        marker.snippet = Des
        marker.map = mapView
        marker.icon = icon
                
        
        
        mapView?.frame = view.bounds
        mapView!.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        view.addSubview(mapView!)
        
    }
    // ------------------------------------------------
}
