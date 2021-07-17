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
  @ObservedObject var userObject: UserObject

  var body: some View {
    ScrollView {
      KFImage(URL(string: "https://picsum.photos/500/300")!)
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: UIScreen.main.bounds.width, height: 275)
        .clipped()
      
      
      VStack(alignment: .leading, spacing: 20) {
        Section(header: SectionHeaderView(header: user.name)) {
          HStack {
            Text("age: \(user.age)")
            Spacer()
            Divider()
            Text("company: \(user.company)")
              .padding(.trailing, 20)
          }
          .frame(height: 20)
          Divider()
          Text("email: \(user.email)")
          Divider()
          Text("address: \(user.address)")
          Divider()
          Text("about: \(user.about)")
          Divider()
          Text("joined at: \(user.registered)")
        }
        
        Section(header: SectionHeaderView(header: "Friends")) {
          ForEach(user.friends, id: \.id) { friend in
            let user = userObject.list.first(where: {$0.id == friend.id})
            NavigationLink(
              destination: DetailView(user: user!, userObject: userObject),
              label: {
                Text(friend.name)
              })
          }
        }
        
      }
//      .frame(width: UIScreen.main.bounds.width)
      .navigationTitle(user.name)
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
    return DetailView(user: user, userObject: UserObject())
  }
}
