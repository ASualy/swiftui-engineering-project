//
//  PostsView.swift
//  MobileAcebook
//
//  Created by Avni Sualy on 03/09/2024.
//

import SwiftUI
struct PostsView:View {
    // @State var
    var body: some View {
        ScrollView {
            NavigationView {
                VStack {
                    Text("Welcome User")
                        .padding(50)
                        .font(.largeTitle)
                        .padding(.bottom, 20)
                    
                    Text("Recent Posts")
                        .padding(.leading,20)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    VStack {
                        Image("profile")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .accessibilityIdentifier("profile")
                        Spacer()
                        
                    VStack {}
                    }
                }
            }
        }
    }
}
    

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView()
    }
}
