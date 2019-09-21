//
//  Extensions.swift
//  Gojek Contacts
//
//  Created by Vishwas on 21/09/19.
//  Copyright © 2019 Vishwas. All rights reserved.
//

import Foundation
import UIKit


extension Dictionary {
    func encodeForHTTPBody() -> Data {
        let data = try! JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        
        if let json = json {
            print("HTTPBody: \(json)")
        }
        
        return json!.data(using: String.Encoding.utf8.rawValue)!;
    }
}

extension UIImageView {
   func setRounded() {
    let radius = self.frame.width / 2
      self.layer.cornerRadius = radius
      self.layer.masksToBounds = true
   }
}
