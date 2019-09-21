//
//  APIHelper.swift
//  Gojek Contacts
//
//  Created by Vishwas on 21/09/19.
//  Copyright © 2019 Vishwas. All rights reserved.
//

import Foundation
typealias ServiceResponse = ([ContactsModel], NSError?) -> Void


class API:NSObject {    
    static let shared : API = {
        let instance = API()
        
        return instance
    }()
}

