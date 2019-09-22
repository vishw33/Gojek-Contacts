//
//  SessionCalls.swift
//  Gojek Contacts
//
//  Created by Vishwas on 21/09/19.
//  Copyright © 2019 Vishwas. All rights reserved.
//

import Foundation

extension API {
    
     func getContacts(with contantUrlRequest:URLRequestGetter ,onCompletion: @escaping contactResponse) {
        
        let myUrlRequest =  contantUrlRequest.asURLRequest()
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: myUrlRequest  , completionHandler: { (data, response, error) -> Void in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                    let decoder = JSONDecoder()
                    let contacts = try decoder.decode([ContactsModel].self, from: dataResponse)
                    onCompletion(contacts,nil)
            } catch let parsingError {
                print("Error", parsingError)
            }
        })
        dataTask.resume()
    }
    
    func getDetails(with detailUrlRequest:URLRequestGetter ,onCompletion: @escaping detailResponse) {
        
        let myUrlRequest =  detailUrlRequest.asURLRequest()
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: myUrlRequest  , completionHandler: { (data, response, error) -> Void in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                    let decoder = JSONDecoder()
                    let detailContact = try decoder.decode(DetailContact.self, from: dataResponse)
                    onCompletion(detailContact,nil)
            } catch let parsingError {
                print("Error", parsingError)
            }
        })
        dataTask.resume()
    }
    
    func deleteContact(with deleteUrlRequest:URLRequestGetter , onCompletion: @escaping deleteResponse){
        let myUrlRequest =  deleteUrlRequest.asURLRequest()
        let session = URLSession.shared
        let dataTask = session.dataTask(with: myUrlRequest  , completionHandler: { (data, response, error) -> Void in
                   guard let dataResponse = response as? HTTPURLResponse,
                       error == nil else {
                           print(error?.localizedDescription ?? "Response Error")
                           return }
                    onCompletion((200...299).contains(dataResponse.statusCode),dataResponse.statusCode)
               })
               dataTask.resume()
        
    }
    
    func saveContact(with updateUrlRequest:URLRequestGetter ,onCompletion: @escaping completionResponse)  {
        let myUrlRequest =  updateUrlRequest.asURLRequest()
        let session = URLSession.shared
        let dataTask = session.dataTask(with: myUrlRequest  , completionHandler: { (data, response, error) -> Void in
                   guard let dataResponse = response as? HTTPURLResponse,
                       error == nil else {
                           print(error?.localizedDescription ?? "Response Error")
                           return }
                    onCompletion((200...299).contains(dataResponse.statusCode))
               })
               dataTask.resume()
    }
}
