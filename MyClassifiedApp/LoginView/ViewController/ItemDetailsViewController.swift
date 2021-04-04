//
//  ItemDetailsViewController.swift
//  MyClassifiedApp
//
//  Created by Ashmita on 4/2/21.
//  Copyright © 2021 Ashmita. All rights reserved.
//

import UIKit

class ItemDetailsViewController: UIViewController {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemAddress: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemPhoneNumber: UILabel!
    @IBOutlet weak var itemEmail: UILabel!

    var itemDetails: ItemModal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Item Details"
        self.setupView()
    }
    
    func setupView() {
        let actualUrl = URL(string: itemDetails?.imageUrl ?? "")
        self.itemImageView?.sd_setImage(with: actualUrl, placeholderImage: UIImage(named: "logo"))
        self.itemTitle.text = itemDetails?.title
        self.itemAddress.text = itemDetails?.itemLocation
        self.itemPrice.text = itemDetails?.price
        self.itemPhoneNumber.text = "9875647382"
        self.itemEmail.text = "new@gmail.com"
    }

}
