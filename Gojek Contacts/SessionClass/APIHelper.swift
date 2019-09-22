//
//  APIHelper.swift
//  Gojek Contacts
//
//  Created by Vishwas on 21/09/19.
//  Copyright © 2019 Vishwas. All rights reserved.
//

import Foundation
typealias contactResponse = ([ContactsModel], NSError?) -> Void
typealias detailResponse = (DetailContact, NSError?) -> Void
typealias deleteResponse = (Bool, Int) -> Void
typealias completionResponse = (Bool) -> Void
typealias saveResponse = (Bool, String) -> Void

class API:NSObject {    
    static let shared : API = {
        let instance = API()
        
        return instance
    }()
}

