//
//  User.swift
//  FriendFace
//
//  Created by 山崎宏哉 on 2021/07/15.
//

import SwiftUI
import CoreData

class UserObject: ObservableObject {
  @Published var list: [User] = []
  
  static func deleteAllObject(context: NSManagedObjectContext) {
    
    let request_User_CoreData = NSFetchRequest<NSFetchRequestResult>(entityName: "User_CoreData")
    let request_Friend_CoreData = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend_CoreData")
    let userDeleteRequest = NSBatchDeleteRequest(fetchRequest: request_User_CoreData)
    let FriendDeleteRequest = NSBatchDeleteRequest(fetchRequest: request_Friend_CoreData)
    do {
      try context.persistentStoreCoordinator!.execute(userDeleteRequest, with: context)
      try context.persistentStoreCoordinator!.execute(FriendDeleteRequest, with: context)
      print("Succeeded to execute deleteRequest")
    } catch {
      print("Failed to execute deleteRequest")
    }
  }
  
  static func saveToCoreData(context: NSManagedObjectContext, userList: [User]) {
    let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    privateMOC.parent = context
    
    DispatchQueue.main.async {
      
      for item in userList {
        
        let user = User_CoreData(context: context)
        user.id = item.id
        user.name = item.name
        user.age = Int16(item.age)
        user.about = item.about
        user.email = item.email
        user.address = item.address
        user.company = item.company
        user.isActive = item.isActive
        user.registered = item.registered
        
        //    let friend = Friend_CoreData(context: self.moc)
        //    friend.id = item.id
        //    friend.name = item.name
        
        
        for friend in item.friends {
          let friend_CoreData = Friend_CoreData(context: context)
          friend_CoreData.id = friend.id
          friend_CoreData.name = friend.name
          user.addToFriends(friend_CoreData)
        }
        
        //      user.friends = NSSet(array: friends)
        
        let tagsAsString = item.tags.description
        let tagsAsData = tagsAsString.data(using: String.Encoding.utf16)
        user.tags = tagsAsData
        do {
          try context.save()
        } catch {
          print(error.localizedDescription)
        }
      }
    }
    
  }
}


class User: Codable {
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
  var friends: [Friend] = []
  
  init() {}
  
  init?(coredata: User_CoreData) {
    guard coredata.id != nil else {
      return nil
    }
    
    id = coredata.id!
    isActive = coredata.isActive
    name = coredata.name!
    age = Int(coredata.age)
    company = coredata.wrappedCompany
    email = coredata.wrappedEmail
    address = coredata.wrappedAddress
    about = coredata.wrappedAbout
    registered = coredata.wrappedRegistered
      for friend in coredata.friends! {
        friends.append(Friend(coredata: friend as! Friend_CoreData))
      }
    
  }
  
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
    friends = try container.decode([Friend].self, forKey: .friends)
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

class Friend: Codable {
  enum FriendCodingKeys: CodingKey {
    case id, name
  }
  
  var id: String = ""
  var name: String = ""
  
  init() {}
  
  init(coredata: Friend_CoreData) {
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




//struct User: Codable {
//  var id: String = ""
//  var isActive: Bool = false
//  var name: String = ""
//  var age: Int = 0
//  var company: String = ""
//  var email: String = ""
//  var address: String = ""
//  var about: String = ""
//  var registered: Date
//  var tags: [String] = []
//  var friends: [Friend] = []
//
//
//  init(from decoder: Decoder) throws {
//    let container = try decoder.container(keyedBy: UserCodingKeys.self)
//
//    id = try container.decode(String.self, forKey: .id)
//    isActive = try container.decode(Bool.self, forKey: .isActive)
//    name = try container.decode(String.self, forKey: .name)
//    age = try container.decode(Int.self, forKey: .age)
//    company = try container.decode(String.self, forKey: .company)
//    email = try container.decode(String.self, forKey: .email)
//    address = try container.decode(String.self, forKey: .address)
//    about = try container.decode(String.self, forKey: .about)
//    registered = try container.decode(Date.self, forKey: .registered)
//    tags = try container.decode([String].self, forKey: .tags)
//    friends = try container.decode([Friend].self, forKey: .friends)
//  }
//
//  func encode(to encoder: Encoder) throws {
//    var container = encoder.container(keyedBy: UserCodingKeys.self)
//
//    try container.encode(id, forKey: .id)
//    try container.encode(isActive, forKey: .isActive)
//    try container.encode(name, forKey: .name)
//    try container.encode(age, forKey: .age)
//    try container.encode(company, forKey: .company)
//    try container.encode(email, forKey: .email)
//    try container.encode(address, forKey: .address)
//    try container.encode(about, forKey: .about)
//    try container.encode(registered, forKey: .registered)
//    try container.encode(tags, forKey: .tags)
//    try container.encode(friends, forKey: .friends)
//  }
//}
//
//struct Friend: Codable {
//  var id: String = ""
//  var name: String = ""
//
//  init(from decoder: Decoder) throws {
//    let container = try decoder.container(keyedBy: FriendCodingKeys.self)
//
//    id = try container.decode(String.self, forKey: .id)
//    name = try container.decode(String.self, forKey: .name)
//  }
//
//  func encode(to encoder: Encoder) throws {
//    var container = encoder.container(keyedBy: FriendCodingKeys.self)
//
//    try container.encode(id, forKey: .id)
//    try container.encode(name, forKey: .name)
//  }
//}
