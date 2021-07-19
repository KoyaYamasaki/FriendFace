//
//  DetailView.swift
//  FriendFace
//
//  Created by 山崎宏哉 on 2021/07/15.
//

import SwiftUI
import Kingfisher

struct DetailView: View {
  let user: User
  let userList: [User]

  var body: some View {
    ScrollView {
      KFImage(URL(string: "https://picsum.photos/500/300")!)
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: UIScreen.main.bounds.width, height: 275)
        .clipped()
      
      
      VStack(alignment: .leading, spacing: 20) {
        Section(header: SectionHeaderView(header: user.wrappedName)) {
          HStack {
            Text("age: \(user.age)")
            Spacer()
            Divider()
            Text("company: \(user.wrappedCompany)")
              .padding(.trailing, 20)
          }
          .frame(height: 20)
          Divider()
          Text("email: \(user.wrappedEmail)")
          Divider()
          Text("address: \(user.wrappedAddress)")
          Divider()
          Text("about: \(user.wrappedAbout)")
          Divider()
          Text("joined at: \(user.wrappedRegistered)")
        }
        
        Section(header: SectionHeaderView(header: "Friends")) {
          ForEach(getFriendsArray, id: \.id) { friend in
            let matchedUser = userList.first(where: {$0.id == friend.id})
            NavigationLink(
              destination: DetailView(user: matchedUser!, userList: userList),
              label: {
                Text(friend.wrappedName)
              })
          }
        }
        
      }
//      .frame(width: UIScreen.main.bounds.width)
      .navigationTitle(user.wrappedName)
    }
  } //: Body

  var getFriendsArray: [Friend] {
    if let friends = user.friends {
      let friendArray: [Friend] = friends.toArray()
      return friendArray
    } else {
      return []
    }
  }
}

struct SectionHeaderView: View {
  let header: String

  var body: some View {
    Text(header)
      .frame(width: UIScreen.main.bounds.width)
      .background(Color.gray)
  }
}

struct DetailView_Previews: PreviewProvider {
  static var previews: some View {
    let user = User()
    user.name = "Test name"
    return DetailView(user: user, userList: [user])
  }
}
