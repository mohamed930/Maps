//
//  DirectionViewModel.swift
//  Maps
//
//  Created by Mohamed Ali on 30/08/2021.
//

import Foundation
import RxSwift
import RxCocoa
import MapKit

class DirectionViewModel {
    
    let currentlong = BehaviorRelay<Double>(value: 0.0)
    let currentlati = BehaviorRelay<Double>(value: 0.0)
    let PickedShopNamed = BehaviorRelay<String>(value: "")
    let namesArrBehaviour = BehaviorRelay<[LocationModel]>(value: [])
    let homemapviewmodel = HomeMapViewModel()
    
    func SetMapConfigureOperation(mapView: MKMapView,lati:Double,long:Double) {
        let anotation = MKPointAnnotation()
        
        anotation.coordinate = CLLocationCoordinate2D(latitude: lati, longitude: long)
        
        let range = MKCoordinateRegion(center: anotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.mapType = .satellite
        mapView.setRegion(range, animated: true)
    }
    
    
    // MARK:- TODO:- This Method For Adding Anotation For Picked Place.
    func AddAnotationOperation(mapview: MKMapView , completion: @escaping (Bool) -> Void) {
        
        FirebaseLayer.shared.publicreadWithWhereCondtion(collectionName: locationCollection, k: KShopName, v: PickedShopNamed.value) { [weak self] snapshot, error in
            
            guard let self = self else { return }
            
            if error != nil {
                print("Error in your connection")
                completion(false)
            }
            else {
                
                guard let snapshot = snapshot else {
                    print("No Documnts Here.")
                    completion(false)
                    return
                }
                
                let documnts = snapshot.documents.compactMap { (querysnapshot) -> LocationModel? in
                    return try? querysnapshot.data(as: LocationModel.self)
                }
                
                let allAnnotations = mapview.annotations
                mapview.removeAnnotations(allAnnotations)
                
                self.currentlong.accept(documnts[0].long)
                self.currentlati.accept(documnts[0].lati)
                
                self.MakeLocation(mapView: mapview, Title: documnts[0].shopName, SubTitle: documnts[0].shopDescribtion, lati: documnts[0].lati, long: documnts[0].long)
                completion(true)
                
            }
        }
        
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Making a Pin in Map.
    func MakeLocation (mapView: MKMapView,Title:String,SubTitle:String,lati:Double,long:Double)  {
        
        let anotation = MKPointAnnotation()
        
        anotation.coordinate = CLLocationCoordinate2D(latitude: lati, longitude: long)
        mapView.addAnnotation(anotation)
        anotation.title = Title
        anotation.subtitle = SubTitle
        let range = MKCoordinateRegion(center: anotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.mapType = .satellite
        mapView.setRegion(range, animated: true)
        
    }
    // ------------------------------------------------
    
}
