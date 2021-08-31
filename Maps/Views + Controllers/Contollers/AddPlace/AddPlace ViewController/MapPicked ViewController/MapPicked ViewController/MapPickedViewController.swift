//
//  MapPickedViewController.swift
//  Maps
//
//  Created by Mohamed Ali on 30/08/2021.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation

class MapPickedViewController: UIViewController {

    @IBOutlet weak var Circle1: UIView!
    @IBOutlet weak var Circle2: UIView!
    @IBOutlet weak var Circle3: UIView!
    @IBOutlet weak var Circle4: UIView!
    @IBOutlet weak var MapView: UIView!
    @IBOutlet weak var finishButton: UIButton!
    
    var mappickedviewmodel = MapPickedViewModel()
    var screenedge: UIScreenEdgePanGestureRecognizer!
    let location = CLLocationManager()
    let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ConfigureLocation()
        
        ConfigureProgress()
        
        subscribeToisEnabledFinishButton()
        responseToWriteShop()
        SubscribeToFinishAction()
        ConfigureFinishButton()
    }
    
    // MARK:- TODO:- I used method to call init the naviagation Bar.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ConfigureNavigationBar()
        initScreenEdgeGeuster()
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Configure The Navigation Controller.
    func ConfigureNavigationBar() {
        
        self.navigationItem.title = "Shop located details"
         
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Icons-icon-long-arrow-left")?.withTintColor(.white), style: .plain, target: self, action: #selector(self.BackButtonPressed))
        
    }
    
    @objc func BackButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- Add ScreenEdgePanGesture To This Page.
    func initScreenEdgeGeuster() {
        screenedge = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(Back(_:)))
        
        screenedge.edges = .left
        
        view.addGestureRecognizer(screenedge)
    }
    
    @objc func Back (_ sender:UIScreenEdgePanGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Configure the View Cricle.
    func ConfigureProgress() {
        
        Circle1.SetCornerRadious(BackgroundColor: "#FFFFFF", BorderColor: "#000000")
        Circle2.SetCornerRadious(BackgroundColor: "#76FF00", BorderColor: "#21AA00")
        Circle3.SetCornerRadious(BackgroundColor: "#FFFFFF", BorderColor: "#000000")
        Circle4.SetCornerRadious(BackgroundColor: "#FD0707", BorderColor: "#FD8FAE")
        
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Configure Finish Button.
    func ConfigureFinishButton() {
        finishButton.MakeCornerRadious(BackGroundColour: buttonBackGround, BorderColour: buttonBorderColour)
    }
    // ------------------------------------------------
    
    
    func subscribeToisEnabledFinishButton() {
        mappickedviewmodel.isFinishButtonEnabled.subscribe(onNext: { [weak self] isnotEmpty in
            
            guard let self = self else { return }
            
            if isnotEmpty {
                self.finishButton.isEnabled = true
            }
            else {
                self.finishButton.isEnabled = false
            }
            
        }).disposed(by: disposebag)
    }
    
    func responseToWriteShop() {
        mappickedviewmodel.responseBehaviour.subscribe(onNext: { [weak self] response in
            
            guard let self = self else { return }
            
            if response {
                let story = self.storyboard?.instantiateViewController(withIdentifier: "DoneButton")
                
                story?.modalPresentationStyle = .fullScreen
                
                self.present(story!, animated: true)
            }
            
        }).disposed(by: disposebag)
    }
    
    // MARK:- TODO:- This Method For Configure the Finish Button Action.
    func SubscribeToFinishAction() {
        
        finishButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
            
            guard let self = self else { return }
            
                self.finishButton.isEnabled = false
                self.mappickedviewmodel.AddShopsOperation()
            
        }).disposed(by: disposebag)
        
    }
    
    
    // MARK:- TODO:- This Method For Configure The Location.
    func ConfigureLocation() {
         location.delegate = self
         location.desiredAccuracy = kCLLocationAccuracyHundredMeters
         location.requestWhenInUseAuthorization()
         location.startUpdatingLocation()
    }
    // ------------------------------------------------

}
