//
//  AddPlaceViewController.swift
//  Maps
//
//  Created by Mohamed Ali on 30/08/2021.
//

import UIKit
import RxCocoa
import RxSwift

class AddPlaceViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    // MARK:- TODO:- initials IBOutles here.
    @IBOutlet weak var Circle1: UIView!
    @IBOutlet weak var Circle2: UIView!
    @IBOutlet weak var Circle3: UIView!
    @IBOutlet weak var Circle4: UIView!
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var Line1: UIView!
    @IBOutlet weak var Line2: UIView!
    @IBOutlet weak var ShopNameLabel: UILabel!
    @IBOutlet weak var ShopDetailsLabel: UILabel!
    @IBOutlet weak var ShopNameTextField: UITextField!
    @IBOutlet weak var ShopDetailsTextField: UITextField!
    @IBOutlet weak var PickImageButton: UIButton!
    @IBOutlet weak var ShopIconImageView: UIImageView!
    
    // MARK:- TODO:- Intialise New varibles here.
    var addplaceviewmodel = AddPlaceViewModel()
    var imagePicker = UIImagePickerController()
    var img: UIImage?
    var disposebag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindTextFieldToRxSwift()

        ConfigureProgress()
        
        ConfigureNextButton()
        SubscribeisButtonNextEnabled()
        SubscriebToNextButtonAction()
        
        AddTapGeusterToImageView()
        
        ConfigureShopIconImage()
        SubscribeToPickImageFromUser()
        
    }
    
    // MARK:- TODO:- Bind TextField To his rxSwift varibles.
    func bindTextFieldToRxSwift() {
        ShopNameTextField.rx.text.orEmpty.bind(to: addplaceviewmodel.ShopNameBehaviour).disposed(by: disposebag)
        ShopDetailsTextField.rx.text.orEmpty.bind(to: addplaceviewmodel.ShopDetailsBehaviour).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- This Method For Configure the View Cricle.
    func ConfigureProgress() {
        
        Circle1.SetCornerRadious(BackgroundColor: "#FFFFFF", BorderColor: "#000000")
        Circle2.SetCornerRadious(BackgroundColor: "#FF0000", BorderColor: "#FF004E")
        Circle3.SetCornerRadious(BackgroundColor: "#FFFFFF", BorderColor: "#000000")
        Circle4.SetCornerRadious(BackgroundColor: "#FFFFFF", BorderColor: "#000000")
        
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For ConfigureButton Shape.
    func ConfigureNextButton() {
        NextButton.MakeCornerRadious(BackGroundColour: buttonBackGround, BorderColour: buttonBorderColour)
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This Method For Active Button Next or not.
    func SubscribeisButtonNextEnabled() {
        addplaceviewmodel.isNextButtonEnabled.subscribe(onNext: { [weak self] isEnabled in
            
            guard let self = self else { return }
            
            if isEnabled {
                self.NextButton.isEnabled = true
            }
            else {
                self.NextButton.isEnabled = false
            }
            
        }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- This method For Adding Action To NextButton.
    func SubscriebToNextButtonAction() {
        NextButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                
                guard let self = self else { return }
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let nextvc = storyboard.instantiateViewController(withIdentifier: "PickedMapViewController") as! MapPickedViewController
                nextvc.modalPresentationStyle = .fullScreen
                
                if let img = self.img {
                    self.addplaceviewmodel.ShopIconBehaviour.accept(img)
                }
                else {
                    self.img = UIImage(named: "load_image")
                    self.addplaceviewmodel.ShopIconBehaviour.accept(self.img)
                }
                
                nextvc.mappickedviewmodel.ShopNameBehaviour.accept(self.addplaceviewmodel.ShopNameBehaviour.value)
                nextvc.mappickedviewmodel.ShopDetailsBehaviour.accept(self.addplaceviewmodel.ShopDetailsBehaviour.value)
                nextvc.mappickedviewmodel.ShopIconBehaviour.accept(self.addplaceviewmodel.ShopIconBehaviour.value)
                nextvc.mappickedviewmodel.longBehaviour.accept(0.0)
                nextvc.mappickedviewmodel.latiBehaviour.accept(0.0)
                
                self.navigationController?.pushViewController(nextvc, animated: true)
            }).disposed(by: disposebag)
    }
    // ------------------------------------------------
    
    // MARK:- TODO:- Configure ImageView Shape.
    func ConfigureShopIconImage() {
        
        self.ShopIconImageView.layer.cornerRadius = self.ShopIconImageView.frame.size.width / 2
        self.ShopIconImageView.layer.masksToBounds = true
        
    }
    
    // MARK:- TODO:- This Method For Opening Gallery and Picked ShopIcon.
    func SubscribeToPickImageFromUser() {
        
        PickImageButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
                
                guard let self = self else { return }
                
                // Call Method For open Gallery
                self.OpenGallarey()
                
            }).disposed(by: disposebag)
        
    }
    
    func OpenGallarey() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        self.ShopIconImageView.image = image
        self.img = image
    }
    
    // ------------------------------------------------
    
    
    
    // MARK:- TODO:- This Method For Adding TapGeuster To ImageView.
    func AddTapGeusterToImageView() {
        let tab = UITapGestureRecognizer(target: self, action: #selector(PickImage(tapGestureRecognizer:)))
       tab.numberOfTapsRequired = 1
       tab.numberOfTouchesRequired = 1
       ShopIconImageView.isUserInteractionEnabled = true
       ShopIconImageView.addGestureRecognizer(tab)
        
    }
    
    @objc func PickImage(tapGestureRecognizer: UITapGestureRecognizer) {
       OpenGallarey()
    }
    // ------------------------------------------------
    
    
    // MARK:- TODO:- When touch any where dismiss keypad.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        Line2.layer.backgroundColor = UIColor().hexStringToUIColor(hex: "#434343").cgColor
        Line1.layer.backgroundColor = UIColor().hexStringToUIColor(hex: "#434343").cgColor
    }
    
}
