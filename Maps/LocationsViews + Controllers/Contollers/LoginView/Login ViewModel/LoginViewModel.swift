//
//  LoginViewModel.swift
//  Maps
//
//  Created by Mohamed Ali on 24/09/2021.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    
    // MARK:- TODO:- Make RxSwift Varibles.
    let emailBehaviour = BehaviorRelay<String>(value: "")
    let passwordBehaviour = BehaviorRelay<String>(value: "")
    // ------------------------------------------------
    
    
    // MARK:- TODO:- Make Validation Oberval here.
    var isEmailBehaviour : Observable<Bool> {
        return emailBehaviour.asObservable().map { email -> Bool in
            let isEmailEmpty = email.trimmingCharacters(in: .whitespaces).isEmpty
            
            return isEmailEmpty
        }
    }
    
    var isPasswordBehaviour : Observable<Bool> {
        return passwordBehaviour.asObservable().map { password -> Bool in
            let isPasswordEmpty = password.trimmingCharacters(in: .whitespaces).isEmpty
            
            return isPasswordEmpty
        }
    }
    
    var isLoginButtonEnabled: Observable<Bool> {
        return Observable.combineLatest(isEmailBehaviour,isPasswordBehaviour) {
            emailEmpty , passwordEmpty in
            
            let loginValid = !emailEmpty && !passwordEmpty
            
            return loginValid
        }
    }
    // ------------------------------------------------
}
