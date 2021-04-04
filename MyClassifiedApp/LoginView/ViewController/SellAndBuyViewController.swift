//
//  SellAndBuyViewController.swift
//  MyClassifiedApp
//
//  Created by Prestha on 3/27/21.
//  Copyright © 2021 Prestha. All rights reserved.
//

import UIKit
import DropDown
import FirebaseAuth
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SDWebImage

class SellAndBuyViewController: UIViewController {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleTxtFld: UITextField!
    @IBOutlet weak var categoryDropdown: UITextField!
    @IBOutlet weak var itemConditionDropdown: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var negotiableDropdown: UITextField!
    @IBOutlet weak var paymentOptionDropdown: UITextField!
    
    @IBOutlet weak var descriptionTxtFld: UITextField!
    
    @IBOutlet weak var itemLocation: UITextField!
    let dropDown = DropDown()
    let itemConditionDropDown = DropDown()
    let negotiableItemDropdown = DropDown()
    let paymentOptionItemDropdown = DropDown()
    
     var activityIndicator = UIActivityIndicatorView(style: .large)
    
    var imagePicker: ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Buy And Sell"
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
       
    self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        self.categoryDropdown.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dropDownView)))
        
        self.itemConditionDropdown.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(itemConditionDropDownView)))
        self.negotiableDropdown.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(negotiableDropDownView)))
        self.paymentOptionDropdown.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(paymentOptionDropdownView)))
        
        self.itemImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showImagePicker)))
        self.itemImageView.isUserInteractionEnabled = true
    }
    
    @objc func dropDownView() {
//         self.categoryDropdown.isUserInteractionEnabled = false
        dropDown.dataSource = ["Car", "Phones", "Real Estate"]
        dropDown.anchorView = categoryDropdown //5
        dropDown.bottomOffset = CGPoint(x: 0, y: categoryDropdown.frame.size.height) //6
        dropDown.show() //7
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
            guard let _ = self else { return }
            self?.categoryDropdown.text = item
        }
    }
    
    @objc func itemConditionDropDownView() {
//        self.itemConditionDropdown.isUserInteractionEnabled = false
               
        itemConditionDropDown.dataSource = ["New", "Used"]
        itemConditionDropDown.anchorView = itemConditionDropdown //5
        itemConditionDropDown.bottomOffset = CGPoint(x: 0, y: categoryDropdown.frame.size.height) //6
        itemConditionDropDown.show() //7
        itemConditionDropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
            guard let _ = self else { return }
            self?.itemConditionDropdown.text = item
        }
    }
    
    @objc func negotiableDropDownView() {
//        self.negotiableDropdown.isUserInteractionEnabled = false
        
        negotiableItemDropdown.dataSource = ["Yes", "No"]
        negotiableItemDropdown.anchorView = negotiableDropdown //5
        negotiableItemDropdown.bottomOffset = CGPoint(x: 0, y: categoryDropdown.frame.size.height) //6
        negotiableItemDropdown.show() //7
        negotiableItemDropdown.selectionAction = { [weak self] (index: Int, item: String) in //8
            guard let _ = self else { return }
            self?.negotiableDropdown.text = item
        }
    }
    
    @objc func paymentOptionDropdownView() {
//        self.paymentOptionDropdown.isUserInteractionEnabled = false
        paymentOptionItemDropdown.dataSource = ["Bank Transfer", "eSewa", "Khalti", "Cash"]
        paymentOptionItemDropdown.anchorView = paymentOptionDropdown //5
        paymentOptionItemDropdown.bottomOffset = CGPoint(x: 0, y: categoryDropdown.frame.size.height) //6
        paymentOptionItemDropdown.show() //7
        paymentOptionItemDropdown.selectionAction = { [weak self] (index: Int, item: String) in //8
            guard let _ = self else { return }
            self?.paymentOptionDropdown.text = item
        }
    }
    
    @objc func showImagePicker() {
        print("show")
        self.imagePicker.present(from: itemImageView)
    }
    
    @IBAction func submitItem(_ sender: UIButton) {
        
        activityIndicator.startAnimating()
        if let title = titleTxtFld.text, let description = descriptionTxtFld.text, let category = categoryDropdown.text, let itemCondition = itemConditionDropdown.text , let itemLocation = itemLocation.text, let price = price.text, let negotiation = negotiableDropdown.text, let payementOption = paymentOptionDropdown.text {
            
            uploadMedia { (url) in
                guard let url = url else { return }
                let ref = Database.database().reference(withPath: "Items")
                let userRef = ref.child("items_id").childByAutoId()
                //            let id = userRef.childByAutoId()
                let values = ["Title": title, "Description": description, "Category": category, "ItemCondition": itemCondition, "ItemLocation": itemLocation, "Price": price, "Negotiable": negotiation, "PaymentOption": payementOption, "ImageUrl": url] as [String : Any]
                userRef.setValue(values)
                self.activityIndicator.stopAnimating()
            }
        }
    }

}

extension SellAndBuyViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        self.itemImageView.image = image
//        self.uploadImagePic(img1: image)
    }
    
     func uploadMedia(completion: @escaping (_ url: String?) -> Void) {

        let storageRef = Storage.storage().reference().child("\(Auth.auth().currentUser?.uid ?? "").png")
        if let uploadData = self.itemImageView.image?.jpegData(compressionQuality: 0.5) {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("error")
                    completion(nil)
                } else {

                    storageRef.downloadURL(completion: { (url, error) in

                        print(url?.absoluteString)
                        completion(url?.absoluteString)
                    })

                  //  completion((metadata?.downloadURL()?.absoluteString)!))
                    // your uploaded photo url.


                }
            }
        }
    }
    
    
}
