//
//  User_CoreData+CoreDataProperties.swift
//  FriendFace
//
//  Created by 山崎宏哉 on 2021/07/17.
//
//

import Foundation
import CoreData


extension User_CoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User_CoreData> {
        return NSFetchRequest<User_CoreData>(entityName: "User_CoreData")
    }

    @NSManaged public var about: String?
    @NSManaged public var address: String?
    @NSManaged public var age: Int16
    @NSManaged public var company: String?
    @NSManaged public var email: String?
    @NSManaged public var id: String?
    @NSManaged public var isActive: Bool
    @NSManaged public var name: String?
    @NSManaged public var registered: String?
    @NSManaged public var tags: Data?
    @NSManaged public var friends: NSSet?

  var wrappedAbout: String {
    about ?? ""
  }

  var wrappedAddress: String {
    address ?? ""
  }

  var wrappedCompany: String {
    company ?? "Not set"
  }

  var wrappedEmail: String {
    email ?? "Not set"
  }

  var wrappedRegistered: String {
    registered ?? "Not set"
  }
}

// MARK: Generated accessors for friends
extension User_CoreData {

    @objc(addFriendsObject:)
    @NSManaged public func addToFriends(_ value: Friend_CoreData)

    @objc(removeFriendsObject:)
    @NSManaged public func removeFromFriends(_ value: Friend_CoreData)

    @objc(addFriends:)
    @NSManaged public func addToFriends(_ values: NSSet)

    @objc(removeFriends:)
    @NSManaged public func removeFromFriends(_ values: NSSet)

}

extension User_CoreData : Identifiable {

}
