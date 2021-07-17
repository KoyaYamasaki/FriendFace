//
//  Friend_CoreData+CoreDataProperties.swift
//  FriendFace
//
//  Created by 山崎宏哉 on 2021/07/17.
//
//

import Foundation
import CoreData


extension Friend_CoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Friend_CoreData> {
        return NSFetchRequest<Friend_CoreData>(entityName: "Friend_CoreData")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var origin: User_CoreData?

}

extension Friend_CoreData : Identifiable {

}
