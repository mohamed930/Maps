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
    
    let responseBehaviour = BehaviorRelay<Bool>(value: false)
    
    // MARK:- TODO:- Make Validation Oberval here.
    var islongBehaviour : Observable<Bool> {
        return longBehaviour.asObservable().map { long -> Bool in
            let islongEmpty = long.isZero
            
            return islongEmpty
        }
    }
    
    // MARK:- TODO:- Make Validation Oberval here.
    var islatiBehaviour : Observable<Bool> {
        return latiBehaviour.asObservable().map { lati -> Bool in
            let islatiEmpty = lati.isZero
            
            return islatiEmpty
        }
    }
    
    var isFinishButtonEnabled: Observable<Bool> {
        return Observable.combineLatest(islongBehaviour,islatiBehaviour) {
            emailEmpty , passwordEmpty in
            
            let loginValid = !emailEmpty && !passwordEmpty
            
            return loginValid
        }
    }
    
    
    // MARK:- TODO:- This Method For Add New Places to Database.
    func AddShopsOperation() {
        
        let uid = UUID().uuidString
        
        let date = Date()
        
        let imgFolder = "Photo/\(date)"
        
        print("Please Wait")
        responseBehaviour.accept(false)
        
        FirebaseLayer.shared.uploadMedia(ImageFolder: imgFolder, PickedImage: ShopIconBehaviour.value!) { [weak self] url in
            
            guard let self = self else { return }
            guard let url = url else { return }
            
            let data = LocationModel(id: uid, shopName: self.ShopNameBehaviour.value , shopDescribtion: self.ShopDetailsBehaviour.value , shopicon: url, long: self.longBehaviour.value , lati: self.latiBehaviour.value)
            
            FirebaseLayer.shared.WriteMessageToFirebase(collectionName: locationCollection , ob: data, id: uid)
            
            print("Added")
            
            self.responseBehaviour.accept(true)
        }
        
        
    }
    // ------------------------------------------------
    
}
