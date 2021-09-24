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
    
    let reponseBehaviour = BehaviorRelay<Bool?>(value: nil)
    let errorBehaviour = BehaviorRelay<String>(value: "")
    
    let forgetpasswordBehaviour = BehaviorRelay<String?>(value: nil)
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
    
    
    // MARK:- TODO:- This Method For Loging operation.
    func MakeLoginOperation() {
        FirebaseLayer.shared.LoginOperation(email: emailBehaviour.value, password: passwordBehaviour.value) { error, auth in
            
            if error != nil {
                self.reponseBehaviour.accept(true)
                self.errorBehaviour.accept(error!.localizedDescription)
            }
            else {
                self.reponseBehaviour.accept(false)
            }
            
        }
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Resete Password Operation.
    func ResetePasswordOperation() {
        FirebaseLayer.shared.ForgetPassword(email: emailBehaviour.value) { [weak self] resposnse in
            
            guard let self = self else { return }
            
            if resposnse == "Success" {
                self.forgetpasswordBehaviour.accept("Success")
            }
            else {
                self.forgetpasswordBehaviour.accept(resposnse)
            }
            
        }
    }
    // ------------------------------------------------
}
