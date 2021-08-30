//
//  FirebaseLayer.swift
//  Maps
//
//  Created by Mohamed Ali on 29/08/2021.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage

class FirebaseLayer {
    
    public static var shared = FirebaseLayer()
    
    public func refernceCollection (_ collectionName:String) -> CollectionReference {
        return Firestore.firestore().collection(collectionName)
    }
    
    // MARK:- TODO:- This Method For Write Message into Firebae
    public func WriteMessageToFirebase<T: Codable> (collectionName: String ,ob: T, id : String) {
        
        do {
            try refernceCollection(collectionName).document(id).setData(from: ob) {
                error in
                
                if error != nil {
                    print("Error in writing")
                }
                
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method for Read Data from Firebase without condtion in public.
    public func publicreadWithoutWhereCondtion (collectionName:String , complention: @escaping (QuerySnapshot? , Error?) -> ()) {
        
        Firestore.firestore().collection(collectionName).getDocuments { (quary, error) in
            if error != nil {
                complention(nil,error!)
            }
            else {
                complention(quary!,nil)
            }
        }
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method for Read Data from Firebase without condtion in public.
    public func publicreadWithWhereCondtion (collectionName:String , k: String , v: String , complention: @escaping (QuerySnapshot? , Error?) -> ()) {
        
        Firestore.firestore().collection(collectionName).whereField(k, isEqualTo: v).getDocuments { (quary, error) in
            if error != nil {
                complention(nil,error!)
            }
            else {
                complention(quary!,nil)
            }
        }
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method for Upload Image.
    // --------------------------------------------
    public func uploadMedia(ImageFolder: String ,PickedImage:UIImage,completion: @escaping (_ url: String?) -> Void) {
        
       let StorageRef = Storage.storage().reference(forURL: baseImg)
        let starsRef = StorageRef.child(ImageFolder)
       var task: StorageUploadTask!
        
        if let uploadData = PickedImage.jpegData(compressionQuality: 0.5) {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            task = starsRef.putData(uploadData, metadata: metadata) { (metadata, error) in
                
                task.removeAllObservers()
                
                if error != nil {
                    print("error \(error!.localizedDescription)")
                    completion(nil)
                } else {
                    starsRef.downloadURL { (url, error) in
                        if error != nil {
                            print("error \(error!.localizedDescription)")
                        }
                        else {
                            completion(url?.absoluteString)
                        }
                    }
                }
                
            }
            
            
            task.observe(.progress) { snapshot in
                _ = snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount

//                RappleActivityIndicatorView.setProgress(CGFloat(progress))
                
//                if CGFloat(progress) == 100 {
//                    RappleActivityIndicatorView.stopAnimation(completionIndicator: .success, completionLabel: "Completed.", completionTimeout: 1.0)
//                }
                

            }
            
        }
        
    }
    // --------------------------------------------
    
}
