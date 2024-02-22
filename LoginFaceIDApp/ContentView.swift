//
//  ContentView.swift
//  LoginFaceIDApp
//
//  Created by Hakob Ghlijyan on 21.02.2024.
//

import SwiftUI

struct ContentView: View {
    //MARK: - User Log Status
    @AppStorage("log_status") var logStatus: Bool = false
    
    var body: some View {
        NavigationStack {
            if logStatus {
                HomeView()
            } else {
                LoginPage()
                    .navigationBarHidden(true)
            }
        }
    }
}

#Preview {
    ContentView()
}
