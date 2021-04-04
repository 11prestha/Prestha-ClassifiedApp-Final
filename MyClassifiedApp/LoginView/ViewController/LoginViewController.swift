//
//  LoginViewController.swift
//  MyClassifiedApp
//
//  Created by Prestha on 3/14/21.
//  Copyright © 2021 Prestha. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    
    var activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Login"
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    @IBAction func login(_ sender: UIButton) {
        activityIndicator.startAnimating()
        if let email = emailTxtFld.text, let password = passwordTxtFld.text {

            Auth.auth().signIn(withEmail: email, password: password, completion: {(user, error) in
                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    return
                }

                if user != nil && !user!.user.isEmailVerified {
                // User is available, but their email is not verified.
                // Let the user know by an alert, preferably with an option to re-send the verification mail.
                }
                self.presentTabBar()
            })
        }
        
        
    }
    
    func presentTabBar() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
        
        // This is to get the SceneDelegate object from your view controller
        // then call the change root view controller function to change to main tab bar
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
        self.activityIndicator.stopAnimating()
    }
    
}
