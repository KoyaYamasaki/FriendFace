//
//  ContentView.swift
//  FriendFace
//
//  Created by 山崎宏哉 on 2021/07/15.
//

import SwiftUI
import CoreData

struct ContentView: View {
  @Environment(\.managedObjectContext) var moc
  @ObservedObject var userObject = CoreDataHelper()
  @FetchRequest(entity: User.entity(), sortDescriptors: []) var userList: FetchedResults<User>
  @FetchRequest(entity: Friend.entity(), sortDescriptors: []) var friendList: FetchedResults<Friend>
  
  var body: some View {
    NavigationView {
      List(userObject.list, id: \.id) { user in
        NavigationLink(destination: DetailView(user: user, userObject: userObject)) {
          VStack(alignment: .leading) {
            Text(user.name)
            Text(user.isActive ? "🟢Online" : "🔴Offline")
              .font(.caption)
              .foregroundColor(.gray)
          }
        }
      }
      .onAppear(perform: {
        if !userList.isEmpty {
          for item in userList {
            if let user = UserWrapper(coredata: item) {
              userObject.list.append(user)
            }
          }
        } else {
          getFriendFace()
        }
      })
      .navigationTitle("Friend Face")
      .navigationBarItems(
        trailing: Button("Delete CoreData") {
          CoreDataHelper.deleteAllObject(context: moc, entityName: "User")
          CoreDataHelper.deleteAllObject(context: moc, entityName: "Friend")
      })
    }
  }
  
  func getFriendFace() {
    
    let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!
    let request = URLRequest(url: url)
    
    URLSession.shared.dataTask(with: request) { data, response, error in
      guard let data = data else {
        print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
        return
      }
      
      if let decodedOrder = try? JSONDecoder().decode([UserWrapper].self, from: data) {
        CoreDataHelper.saveToCoreData(context: moc, userList: decodedOrder)
        DispatchQueue.main.async {
          userObject.list = decodedOrder
        }
      } else {
        print("Invalid response from server")
      }
    }.resume()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
