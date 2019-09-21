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
       
        fetch()
        API.shared.getDetails(with: SessionAPIRequest.FetchContactDetail(id: "11081")) { (details, err) in
            print(details.firstName)
        }
        
        API.shared.deleteContact(with: SessionAPIRequest.DeleteContact(id: "11081")) { (str, val) in
            DispatchQueue.main.async {
                print(str,val)
                self.fetch()
            }
        }
            
        
        
    }
    
    func fetch () {
       
    }
    
    
    // Do any additional setup after loading the view.
}



