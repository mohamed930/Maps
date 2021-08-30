//
//  MapPickedViewModel.swift
//  Maps
//
//  Created by Mohamed Ali on 30/08/2021.
//

import Foundation
import RxSwift
import RxCocoa

class MapPickedViewModel : AddPlaceViewModel {
    
    // MARK:- TODO:- This Method For Add New Places to Database.
    func AddShopsOperation() {
        
        let uid = UUID().uuidString
        
        let date = Date()
        
        let imgFolder = "Photo/\(date)"
        
        print("Please Wait")
        
        FirebaseLayer.shared.uploadMedia(ImageFolder: imgFolder, PickedImage: ShopIconBehaviour.value!) { [weak self] url in
            
            guard let self = self else { return }
            guard let url = url else { return }
            
            let data = LocationModel(id: uid, shopName: self.ShopNameBehaviour.value , shopDescribtion: self.ShopDetailsBehaviour.value , shopicon: url, long: self.longBehaviour.value , lati: self.latiBehaviour.value)
            
            FirebaseLayer.shared.WriteMessageToFirebase(collectionName: locationCollection , ob: data, id: uid)
            
            print("Added")
        }
        
        
    }
    // ------------------------------------------------
    
}
