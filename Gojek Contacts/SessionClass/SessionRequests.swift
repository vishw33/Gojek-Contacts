//
//  Session.swift
//  Gojek Contacts
//
//  Created by Vishwas on 21/09/19.
//  Copyright © 2019 Vishwas. All rights reserved.
//

import Foundation

public protocol URLRequestGetter {
    func asURLRequest() -> URLRequest
}

public typealias Parameters = Dictionary<String, String>
var baseURL:String = "https://gojek-contacts-app.herokuapp.com"
public typealias HTTPHeaders = [String: String]

enum SessionAPIRequest:URLRequestGetter {
    case FetchContact
    case FetchContactDetail(id:String)
    case AddNewContact(parameter:Parameters)
    case UpdateContact(id:String , parameter:Parameters)
    case DeleteContact(id:String)
    
    var method:String {
        switch self {
        case .FetchContact:
            return "GET"
        case .FetchContactDetail:
            return "GET"
        case .AddNewContact:
            return "POST"
        case .UpdateContact:
            return "PUT"
        case .DeleteContact:
            return "DELETE"
        }
    }
    
    
    var path:String {
        switch self {
        case .FetchContact,.AddNewContact:
            return "contacts.json"
        case .FetchContactDetail(let id) , .UpdateContact(let id , _) , .DeleteContact(let id):
            return "\(id).json"
        }
    }
    
    var body:Data? {
        switch self {
        case .FetchContact:
            return nil
        case .FetchContactDetail:
            return nil
        case .AddNewContact(let parameters):
            return parameters.encodeForHTTPBody()
        case .UpdateContact(_,let parameters):
            return parameters.encodeForHTTPBody()
        case .DeleteContact:
            return nil
        }
    }
    
    var headers:[String : String]? {
        switch self {
        case .FetchContact:
            return ["Content-Type": "application/json"]
        case .FetchContactDetail:
            return ["Content-Type": "application/json"]
        case .AddNewContact:
            return ["Content-Type": "application/json"]
        case .UpdateContact:
            return ["Content-Type": "application/json"]
        case .DeleteContact:
            return nil
        }
}
    
    func asURLRequest() -> URLRequest {
        var request = URLRequest(url:(URL(string: baseURL)?.appendingPathComponent(path))! )
        request.httpBody = body
        request.allHTTPHeaderFields = headers
        request.httpMethod = method
        return request
    }
    
    
    
}
