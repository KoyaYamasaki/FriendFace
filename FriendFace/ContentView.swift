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
  @FetchRequest(entity: User.entity(), sortDescriptors: []) var userList: FetchedResults<User>
  
  var body: some View {
    NavigationView {
      List(userList, id: \.id) { user in
        NavigationLink(destination: DetailView(user: user, userList: Array(userList))) {
          VStack(alignment: .leading) {
            Text(user.wrappedName)
            Text(user.isActive ? "🟢Online" : "🔴Offline")
              .font(.caption)
              .foregroundColor(.gray)
          }
        }
      }
      .onAppear(perform: {
        if userList.isEmpty {
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
