//
//  ProfileViewController.swift
//  MyClassifiedApp
//
//  Created by Prestha on 3/27/21.
//  Copyright © 2021 Prestha. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    var activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Profile"
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        logoImageView.layer.cornerRadius = 150/2
        logoImageView.clipsToBounds = true
        self.getUserData()
    }
    
    func getUserData() {
        activityIndicator.startAnimating()
        if let user = Auth.auth().currentUser {
            //            let name = user.displayName
            //            let address = user.add
            
            let ref = Database.database().reference().child("users").child("users_id").child(user.uid)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                print(snapshot)
                if let dict = snapshot.value as? [String: Any],
                    let username = dict["UserName"] as? String,
                    let address = dict["Address"] as? String,
                    let email = dict["Email"] as? String {
                    self.usernameLbl.text = "Username: \(username)"
                    self.addressLbl.text = "Address: \(address)"
                    self.emailLbl.text = "Email: \(email)"
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    @IBAction func logOut(_ sender: UIButton) {
//        self.navigationController?.popToRootViewController(animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
        
        // This is to get the SceneDelegate object from your view controller
        // then call the change root view controller function to change to main tab bar
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginController)
//        self.activityIndicator.stopAnimating()
    }
    
}
