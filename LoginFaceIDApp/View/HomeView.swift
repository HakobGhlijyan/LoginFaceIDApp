//
//  HomeView.swift
//  LoginFaceIDApp
//
//  Created by Hakob Ghlijyan on 21.02.2024.
//

import SwiftUI
import Firebase

struct HomeView: View {
    //MARK: - User Log Status
    @AppStorage("log_status") var logStatus: Bool = false
    
    //MARK: - FaceID Properties
    @AppStorage("use_face_id") var useFaceID: Bool = false
    
//    @AppStorage("use_face_email") var faceIDEmail: String = ""
//    @AppStorage("use_face_password") var faceIDPassword: String = ""
    
    //MARK: - FaceID Keychain Properties
    @Keychain(key: "use_face_email", account: "LoginFaceIDApp") var storedEmail                          // Use THIS Keychain ...
    @Keychain(key: "use_face_password", account: "LoginFaceIDApp") var storedPassword                    // Use THIS Keychain ...
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("logStatus:\(logStatus.description)")
            Text("useFaceID:\(useFaceID.description)")
            
            if logStatus {
                Text("Logged In")
                    .foregroundStyle(.red)
                    .bold()
                
                Button("LogOut") {
                    try? Auth.auth().signOut()
                    logStatus = false
                }
            } else {
                Text("Came as Guest")
            }
            
            if useFaceID {
                //Clearing FaceID
                Button("Disable FaceID") {
                    useFaceID = false
                    
//                    faceIDEmail = ""
//                    faceIDPassword = ""
                    
                    storedEmail = nil
                    storedPassword = nil
                }
            }
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("Home View")
    }
}

#Preview {
    HomeView()
}
