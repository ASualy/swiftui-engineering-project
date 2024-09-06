//
//  ContentTabView.swift
//  MobileAcebook
//
//  Created by Oleg Novikov on 05/09/2024.
//

import SwiftUI

struct ContentTabView: View {
    private let tokenManager = TokenManager()
    var body: some View {
        TabView{
            
            PostsView()
                .tabItem {
                    Image(systemName: "newspaper.fill")
                }
            
            CreatePostView()
                .tabItem {
                    Image(systemName: "bubble.fill")
                }
            
            Text("Search for friend")
                .tabItem {
                    Image(systemName:"person.fill.badge.plus")
                }
            
            ProfileView(token: tokenManager.getToken())
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct ContentTabView_Previews: PreviewProvider {
    static var previews: some View {
        ContentTabView()
    }
}
