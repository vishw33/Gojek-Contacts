//
//  ViewController.swift
//  Gojek Contacts
//
//  Created by Vishwas on 21/09/19.
//  Copyright © 2019 Vishwas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var model:[ContactsModel] = [ContactsModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        API.shared.getDetails(with: SessionAPIRequest.FetchContactDetail(id: "11088")) { (contactDetail, err) in
            print(contactDetail)
        }
        
        API.shared.deleteContact(with: SessionAPIRequest.DeleteContact(id: "11081")) { (str, val) in
            DispatchQueue.main.async {
                print(str,val)
            }
         
        }
        
        var dict = Dictionary<String, Any>()
        dict["first_name"] = "Vishwas"
        dict["last_name"] = "ng"
        dict["email"] = "vishw33@gmail.com"
        dict["phone_number"] = "8867976701"
        dict["favorite"] = true
        
        API.shared.saveContact(with: SessionAPIRequest.AddNewContact(parameter: dict)) { (issaved,val)  in
            if issaved {
                print("i am awsome")
            }
         }
        
    }
}



