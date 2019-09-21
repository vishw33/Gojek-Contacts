//
//  ContactList.swift
//  Gojek Contacts
//
//  Created by Vishwas on 21/09/19.
//  Copyright © 2019 Vishwas. All rights reserved.
//

import Foundation

class contactList {
    var contactListCollection = [ContactsModel]()
    
    static let shared : contactList = {
        let instance = contactList()
        return instance
    }()
    
    private init () { }
    
    func getUpdatedContact(onCompletion: @escaping completionResponse) {
         API.shared.getContacts(with: SessionAPIRequest.FetchContact) { (model, err) in
                          self.contactListCollection = model
                          print(model.count)
                onCompletion(true)
        }
    }
}
