//
//  MobileAcebookApp.swift
//  MobileAcebook
//
//  Created by Josué Estévez Fernández on 30/09/2023.
//

import SwiftUI

@main
struct MobileAcebookApp: App {
    @StateObject var userSession = UserSession()
    
    var body: some Scene {
        WindowGroup {
            WelcomePageView()
                .environmentObject(userSession)
        }
    }
}
