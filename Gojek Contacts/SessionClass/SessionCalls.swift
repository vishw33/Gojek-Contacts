//
//  SessionCalls.swift
//  Gojek Contacts
//
//  Created by Vishwas on 21/09/19.
//  Copyright © 2019 Vishwas. All rights reserved.
//

import Foundation

extension API {
    
    public func getContacts(with contantUrlRequest:URLRequestGetter ,onCompletion: @escaping ServiceResponse) {
        
        let myUrlRequest =  contantUrlRequest.asURLRequest()
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: myUrlRequest  , completionHandler: { (data, response, error) -> Void in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                    let decoder = JSONDecoder()
                    let gitData = try decoder.decode([ContactsModel].self, from: dataResponse)
                    onCompletion(gitData,nil)
            } catch let parsingError {
                print("Error", parsingError)
            }
        })
        dataTask.resume()
        
    }
}
