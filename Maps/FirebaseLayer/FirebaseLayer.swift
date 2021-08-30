//
//  FirebaseLayer.swift
//  Maps
//
//  Created by Mohamed Ali on 29/08/2021.
//

import Foundation
import Firebase
import FirebaseFirestore

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
    
}
