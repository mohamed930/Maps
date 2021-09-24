//
//  LoginViewController.swift
//  Maps
//
//  Created by Mohamed Ali on 24/09/2021.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    // MARK:- TODO:- This Section for initialise new @IBOutlest.
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var forgetPasswordButton: UIButton!
    // ------------------------------------------------
    
    // MARK:- TODO:- This Section for Initialise new varibles.
    let backgroundColor = "#586C62"
    let loginviewmodel = LoginViewModel()
    let disposebag = DisposeBag()
    // ------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        BindToTextField()
        
        configureButton()
        configureLoginisEnabled()
        BindToLoginButtonAction()
        BindToForgetPasswordButtonAction()
    }
    
    // MARK:- TODO:- This Method For Bind To TextField For his rxVaribles.
    func BindToTextField() {
        emailTextField.rx.text.orEmpty.bind(to: loginviewmodel.emailBehaviour).disposed(by: disposebag)
        passwordTextField.rx.text.orEmpty.bind(to: loginviewmodel.passwordBehaviour).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Confgiure Button UI.
    func configureButton() {
        LoginButton.MakeCornerRadious(BackGroundColour: backgroundColor, BorderColour: backgroundColor)
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Make Button Enable/Disable based on textfield status.
    func configureLoginisEnabled() {
        loginviewmodel.isLoginButtonEnabled.subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            
            if result {
                self.LoginButton.isEnabled = true
            }
            else {
                self.LoginButton.isEnabled = false
            }
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Make Action For Login Button.
    func BindToLoginButtonAction() {
        LoginButton.rx.tap.throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { _ in
            print("Login Button Action Tapped")
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Action For Forget Password Button.
    func BindToForgetPasswordButtonAction() {
        forgetPasswordButton.rx.tap.throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { _ in
            print("Foget Password Button Action Tapped")
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Show Password Button.
    @IBAction func ShowPasswordAction (_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            passwordTextField.isSecureTextEntry = true
        }
        else {
            sender.isSelected = true
            passwordTextField.isSecureTextEntry = false
        }
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Dismiss keypad if user touch any where in screen.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // ------------------------------------------------
}
