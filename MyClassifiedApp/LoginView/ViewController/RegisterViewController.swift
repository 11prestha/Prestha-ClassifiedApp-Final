//
//  RegisterViewController.swift
//  MyClassifiedApp
//
//  Created by Prestha on 3/14/21.
//  Copyright © 2021 Prestha. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var usernameTxtFld: UITextField!
    @IBOutlet weak var addressTxtFld: UITextField!
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    
    let data = Database.database().reference(withPath: "users")
    var activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @IBAction func register(_ sender: UIButton) {
        activityIndicator.startAnimating()
        if let email = emailTxtFld.text, let password = passwordTxtFld.text, let username = usernameTxtFld.text, let address = addressTxtFld.text {
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if let _eror = error {
                    //something bad happning
                    print(_eror.localizedDescription )
                }else{
                    //user registered successfully
                    let ref = Database.database().reference(withPath: "users")
                    let userRef = ref.child("users_id").child(result?.user.uid ?? "")
                    let values = ["Email": email, "UserName": username, "Address": address]
                    userRef.setValue(values)
                    self.dismiss(animated: true, completion: nil)
                    self.activityIndicator.stopAnimating()
                }
            }
        }
        
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
