//
//  FriendWrapper.swift
//  FriendFace
//
//  Created by 山崎宏哉 on 2021/07/19.
//

import Foundation

class FriendWrapper: Codable {
  enum FriendCodingKeys: CodingKey {
    case id, name
  }
  
  var id: String = ""
  var name: String = ""
  
  init() {}
  
  init(coredata: Friend) {
    self.id = coredata.id!
    self.name = coredata.name!
  }
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: FriendCodingKeys.self)
    
    id = try container.decode(String.self, forKey: .id)
    name = try container.decode(String.self, forKey: .name)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: FriendCodingKeys.self)
    
    try container.encode(id, forKey: .id)
    try container.encode(name, forKey: .name)
  }
}
