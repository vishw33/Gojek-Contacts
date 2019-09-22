//
//  ContactDetailViewController.swift
//  Gojek Contacts
//
//  Created by Vishwas on 21/09/19.
//  Copyright © 2019 Vishwas. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradient()

        // Do any additional setup after loading the view.
    }
    
    func setGradient() {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor(white: 1, alpha: 0.9), UIColor(red: 53/255.0, green: 255/255.0, blue: 250/255.0, alpha: 1).cgColor]
        gradient.frame = self.headerView.layer.frame
        self.headerView.layer.insertSublayer(gradient, at: 0)
    }

}
