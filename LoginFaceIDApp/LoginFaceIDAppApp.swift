//
//  LoginFaceIDAppApp.swift
//  LoginFaceIDApp
//
//  Created by Hakob Ghlijyan on 21.02.2024.
//

import SwiftUI
import Firebase

@main
struct LoginFaceIDAppApp: App {
    
    //MARK: - INIT
    // For init Firebase
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
