//
//  ContactsModel.swift
//  Gojek Contacts
//
//  Created by Vishwas on 21/09/19.
//  Copyright © 2019 Vishwas. All rights reserved.
//

import Foundation

struct ContactsModel: Codable {
    let id: Int?
    let firstName, lastName: String?
    let profilePic: String?
    let favorite: Bool?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case profilePic = "profile_pic"
        case favorite, url
    }
}
