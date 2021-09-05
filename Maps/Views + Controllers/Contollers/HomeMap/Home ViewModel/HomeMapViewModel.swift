//
//  HomeMapViewModel.swift
//  Maps
//
//  Created by Mohamed Ali on 29/08/2021.
//

import Foundation
import RxSwift
import RxCocoa
import GoogleMaps
import Kingfisher

class HomeMapViewModel {
    
    // MARK:- TODO:- This Section For initialise new rx varibles
    let textFieldBehaviour = BehaviorRelay<String>(value: "")
    let namesBehaviour = BehaviorRelay<[LocationModel]>(value: [])
    let FilteredBehaviour = BehaviorRelay<[LocationModel]>(value: [])
    let BackupBehaviour = BehaviorRelay<[LocationModel]>(value: [])
    
    let PickedNameBehaviour = BehaviorRelay<String>(value: "")
    
    let CatagoryArrBehaviour = BehaviorRelay<[String]>(value: [])
    let PickedCatagoryBehaviour = BehaviorRelay<String>(value: "")
    
    let disposebag = DisposeBag()
    // ------------------------------------------------
    
    
    // MARK:- TODO:- Initialise map varibles.
    let apiKey = "AIzaSyBBj9ciIrTveza-147dJ81OcCGvsSYrPfo"
    var mapView:GMSMapView?
    var camera:GMSCameraPosition?
    // ------------------------------------------------
    
    
    // MARK:- TODO:- Make Validation Oberval here.
    var isSearchBehaviour : Observable<Bool> {
        return textFieldBehaviour.asObservable().map { search -> Bool in
            let isSearchEmpty = search.trimmingCharacters(in: .whitespaces).isEmpty
           
            return isSearchEmpty
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
    
    
    
    // MARK:- TODO:- Get Places we saved it firebase.
    func GetNamesOperation(completion: @escaping (Bool) -> Void) {
        
        FirebaseLayer.shared.publicreadWithoutWhereCondtion(collectionName: locationCollection) { [weak self] snapshot, error in
            
            guard let self = self else { return }
            
            if error != nil {
                print("Error in your Connection")
                completion(false)
            }
            else {
                
                guard let snapshot = snapshot else {
                    print("No Documnts here.")
                    return
                }
                
                let documnts = snapshot.documents.compactMap { (querysnapshot) -> LocationModel? in
                    return try? querysnapshot.data(as: LocationModel.self)
                }
                
                self.namesBehaviour.accept(documnts)
                self.BackupBehaviour.accept(documnts)
                
                completion(true)
                
            }
        }
        
    }
    // ------------------------------------------------
    
    
    
    // MARK:- TODO:- Show Shop Details in the map and add pin place into map.
    func SearchPlaceOperation(View: UIView) {
        
        mapView!.removeFromSuperview()
        
        for i in namesBehaviour.value {
            if i.shopName == PickedNameBehaviour.value {
                CreateAnnotation(view: View, long: i.long, latit: i.lati, Title: i.shopName, Des: i.shopDescribtion, iconUrl: i.shopicon, zoom: 17)
                break
            }
        }
    }
    
    
    private func CreateAnnotation (view: UIView,long: Double, latit: Double,Title: String, Des: String,iconUrl: String ,zoom: Float) {
            
        setApiKEY()
        
        // Creates a marker in the center of the map.
        camera = GMSCameraPosition.camera(withLatitude: latit, longitude: long, zoom: zoom)
        mapView = GMSMapView.map(withFrame: view.frame, camera: camera!)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latit, longitude: long)
        marker.title = Title
        marker.snippet = Des
        marker.map = mapView
        
        DispatchQueue.main.async {
            
            let resource = ImageResource(downloadURL: URL(string: iconUrl)!)
            
            KingfisherManager.shared.retrieveImage(with: resource) { result in
                switch result {
                
                case .success(let value):
                    marker.icon = value.image.imageWithSize(scaledToSize: CGSize(width: 45, height: 45))
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
            
        }
        
        
        
        mapView?.frame = view.bounds
        mapView!.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        view.addSubview(mapView!)
        
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For SearchInFirebase and Gett Data and Show to Map.
    func SearchInDatabaseAndShowOperation(view: UIView) {
        
        for i in namesBehaviour.value {
            
            if i.shopName.lowercased().contains(textFieldBehaviour.value.lowercased()) {
                mapView!.removeFromSuperview()
                
                CreateAnnotation(view: view, long: i.long, latit: i.lati, Title: i.shopName, Des: i.shopDescribtion, iconUrl: i.shopicon, zoom: 17)
                break
            }
        }
        
    }
    // ------------------------------------------------
    
    
    
    // MARK:- TODO:- This method For Filter Array DropDown and show to user.
    func FilterOperation() {
        let queryResult = textFieldBehaviour.map { query in
            self.namesBehaviour.value.filter { user in
                query.isEmpty || user.shopName.lowercased().contains(query.lowercased())
            }
        }
        
        queryResult.asObservable().subscribe(onNext: { [weak self] usermodel in
         
            guard let self = self else { return }
         
         self.namesBehaviour.accept(usermodel)
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    
    
    // MARK:- TODO:- When User Selected All Locations Show it in the map.
    func ShowAllLocationOperation(view: UIView,long: Double, latit: Double,zoom: Float) {
        
        CreateAnnotations(view: view, long: long, latit: latit, zoom: zoom, Arr: namesBehaviour.value)
        
    }
    
    
    func CreateAnnotations (view: UIView,long: Double, latit: Double,zoom: Float,Arr: [LocationModel]) {
            
        setApiKEY()
        
        // Creates a marker in the center of the map.
        camera = GMSCameraPosition.camera(withLatitude: latit, longitude: long, zoom: zoom)
        mapView = GMSMapView.map(withFrame: view.frame, camera: camera!)
        var bounds = GMSCoordinateBounds()
        
        for i in Arr {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: i.lati , longitude: i.long)
            marker.title = i.shopName
            marker.snippet = i.shopDescribtion
            
            DispatchQueue.main.async {
                
                let resource = ImageResource(downloadURL: URL(string: i.shopicon)!)
                
                KingfisherManager.shared.retrieveImage(with: resource) { result in
                    switch result {
                    
                    case .success(let value):
                        marker.icon = value.image.imageWithSize(scaledToSize: CGSize(width: 45, height: 45))
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
                
            }
            
            marker.map = mapView
            bounds = bounds.includingCoordinate(marker.position)
        }
        
        let update = GMSCameraUpdate.fit(bounds, withPadding: 100)
        mapView!.animate(with: update)
        
        mapView?.frame = view.bounds
        mapView!.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        view.addSubview(mapView!)
        
    }
    
    // MARK:- TODO:- This Method For Fill Catagory.
    func FillCatagoryOperation() {
        CatagoryArrBehaviour.accept(CatagoryArr)
    }
    // ------------------------------------------------
    
}
