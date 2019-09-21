//
//  ViewController.swift
//  Gojek Contacts
//
//  Created by Vishwas on 21/09/19.
//  Copyright © 2019 Vishwas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        API.shared.getContacts(with: SessionAPIRequest.FetchContact) { (model, err) in
            print(model.count)
        }
        }
    
        // Do any additional setup after loading the view.
    }



