//
//  HomeViewController.swift
//  MyClassifiedApp
//
//  Created by Prestha on 3/27/21.
//  Copyright © 2021 Prestha. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase
import SDWebImage

class HomeViewController: UIViewController {
    
    var activityIndicator = UIActivityIndicatorView(style: .large)

    @IBOutlet weak var tableView: UITableView!
    
    var itemsList = [ItemModal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Home"
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        self.getItemList()
    }
    
    func getItemList() {
        activityIndicator.startAnimating()
        let ref = Database.database().reference().child("Items").child("items_id")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot)
            if let dict = snapshot.children.allObjects as? [DataSnapshot] {
                
                for snap in dict {
                    if let userDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let title = userDict["Title"] as? String ?? ""
                        let description = userDict["Description"] as? String ?? ""
                        let itemCondition = userDict["ItemCondition"] as? String ?? ""
                        let category = userDict["Category"] as? String ?? ""
                        let location = userDict["ItemLocation"] as? String ?? ""
                        let price = userDict["Price"] as? String ?? ""
                        let negotiation = userDict["Negotiable"] as? String ?? ""
                        let payment = userDict["PaymentOption"] as? String ?? ""
                        let image = userDict["ImageUrl"] as? String ?? ""
                        
                        let u = ItemModal(title: title, description: description, category: category, itemCondition: itemCondition, itemLocation: location, price: price, negotiation: negotiation, paymentOption: payment, imageUrl: image)
                        self.itemsList.append(u)
                        self.tableView.reloadData()
                    }
                }
            }
            self.activityIndicator.stopAnimating()
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.titleLbl.text = "Title: \(itemsList[indexPath.row].title ?? "")"
        cell.addressLbl.text = "Address: \(itemsList[indexPath.row].category ?? "")"
        cell.priceLbl.text = "Price: \(itemsList[indexPath.row].price ?? "")"
        let actualUrl = URL(string: itemsList[indexPath.row].imageUrl ?? "")
        cell.itemImageView?.sd_setImage(with: actualUrl, placeholderImage: UIImage(named: "logo"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ItemDetailsViewController") as? ItemDetailsViewController
        vc?.itemDetails = itemsList[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}
