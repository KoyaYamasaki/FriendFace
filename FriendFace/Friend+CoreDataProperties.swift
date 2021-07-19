//
//  Friend+CoreDataProperties.swift
//  FriendFace
//
//  Created by 山崎宏哉 on 2021/07/17.
//
//

import Foundation
import CoreData


extension Friend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Friend> {
        return NSFetchRequest<Friend>(entityName: "Friend")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var origin: User?

}

extension Friend : Identifiable {

}
