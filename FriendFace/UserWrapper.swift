//
//  User.swift
//  FriendFace
//
//  Created by 山崎宏哉 on 2021/07/15.
//

import SwiftUI

class UserWrapper: Codable {
  enum UserCodingKeys: CodingKey {
    case id, isActive, name, age, company, email, address, about, registered, tags, friends
  }
  
  var id: String = ""
  var isActive: Bool = false
  var name: String = ""
  var age: Int = 0
  var company: String = ""
  var email: String = ""
  var address: String = ""
  var about: String = ""
  var registered: String = ""
  var tags: [String] = []
  var friends: [FriendWrapper] = []
  
  init() {}
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: UserCodingKeys.self)
    
    id = try container.decode(String.self, forKey: .id)
    isActive = try container.decode(Bool.self, forKey: .isActive)
    name = try container.decode(String.self, forKey: .name)
    age = try container.decode(Int.self, forKey: .age)
    company = try container.decode(String.self, forKey: .company)
    email = try container.decode(String.self, forKey: .email)
    address = try container.decode(String.self, forKey: .address)
    about = try container.decode(String.self, forKey: .about)
    registered = try container.decode(String.self, forKey: .registered)
    tags = try container.decode([String].self, forKey: .tags)
    friends = try container.decode([FriendWrapper].self, forKey: .friends)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: UserCodingKeys.self)
    
    try container.encode(id, forKey: .id)
    try container.encode(isActive, forKey: .isActive)
    try container.encode(name, forKey: .name)
    try container.encode(age, forKey: .age)
    try container.encode(company, forKey: .company)
    try container.encode(email, forKey: .email)
    try container.encode(address, forKey: .address)
    try container.encode(about, forKey: .about)
    try container.encode(registered, forKey: .registered)
    try container.encode(tags, forKey: .tags)
    try container.encode(friends, forKey: .friends)
  }
}
