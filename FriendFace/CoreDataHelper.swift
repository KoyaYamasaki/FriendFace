//
//  CoreDataHelper.swift
//  FriendFace
//
//  Created by 山崎宏哉 on 2021/07/19.
//

import Foundation
import CoreData

class CoreDataHelper: ObservableObject {
  @Published var list: [UserWrapper] = []
  
  static func deleteAllObject(context: NSManagedObjectContext, entityName: String) {
    
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
    do {
      try context.persistentStoreCoordinator!.execute(deleteRequest, with: context)
      print("Succeeded to execute deleteRequest")
    } catch {
      print("Failed to execute deleteRequest")
    }
  }
  
  static func saveToCoreData(context: NSManagedObjectContext, userList: [UserWrapper]) {
    
    DispatchQueue.main.async {
      
      for item in userList {
        
        let user = User(context: context)
        user.id = item.id
        user.name = item.name
        user.age = Int16(item.age)
        user.about = item.about
        user.email = item.email
        user.address = item.address
        user.company = item.company
        user.isActive = item.isActive
        user.registered = item.registered

        for friend in item.friends {
          let friend_CoreData = Friend(context: context)
          friend_CoreData.id = friend.id
          friend_CoreData.name = friend.name
          user.addToFriends(friend_CoreData)
        }
        
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

extension NSSet {
  func toArray<T>() -> [T] {
    let array = self.map({ $0 as! T})
    return array
  }
}

//extension Date {
//  var dayAndMonth: String {
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyy/MM/dd"
//    return dateFormatter.string(from: self)
//  }
//}
