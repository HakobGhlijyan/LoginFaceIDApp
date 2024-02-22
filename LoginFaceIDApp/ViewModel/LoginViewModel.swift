//
//  LoginViewModel.swift
//  LoginFaceIDApp
//
//  Created by Hakob Ghlijyan on 21.02.2024.
//

import SwiftUI
import Firebase
import LocalAuthentication

class LoginViewModel: ObservableObject {
    //MARK: - For TextField
    @Published var email: String = ""
    @Published var password: String = ""
    
    //MARK: - User Log Status
    @AppStorage("log_status") var logStatus: Bool = false
    
    //MARK: - FaceID Properties
    @AppStorage("use_face_id") var useFaceID: Bool = false
    
//    @AppStorage("use_face_email") var faceIDEmail: String = ""
//    @AppStorage("use_face_password") var faceIDPassword: String = ""
    
    //MARK: - FaceID Keychain Properties
    @Keychain(key: "use_face_email", account: "LoginFaceIDApp") var storedEmail                          // Use THIS Keychain ...
    @Keychain(key: "use_face_password", account: "LoginFaceIDApp") var storedPassword                    // Use THIS Keychain ...
    
    //MARK: - Error - Fir Alert
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    var isDisabled: Bool {
        email.isEmpty || password.isEmpty
    }
    
    //MARK: - FaceID FireBase Login
    func loginUserFireBase(useFaceID: Bool, email:String = "", password:String = "") async throws {
    
        let _ = try await Auth.auth().signIn(
            withEmail: email != "" ? email : self.email ,
            password: password != "" ? password : self.password)
        //1
        /*
         DispatchQueue.main.async {
             //Stroing once
             if useFaceID && self.faceIDEmail == "" {                   //sdes u nas pustaya stroka
                 self.useFaceID = useFaceID
                 
                 //MARK: - Storing for future faceid Login
                 self.faceIDEmail = self.email
                 self.faceIDPassword = self.password
             }
             self.logStatus = true
         }
         */
        //2
        DispatchQueue.main.async {
            //Stroing once
            if useFaceID && self.storedEmail == nil {
                self.useFaceID = useFaceID
                
                //MARK: - Setting data is sample as @AppStorage
                // Данные настройки приведены в качестве примера.
                let emailData = self.email.data(using: .utf8)
                let passwordData = self.password.data(using: .utf8)
                
                self.storedEmail = emailData
                self.storedPassword = passwordData
                print("Stored")
            }
            self.logStatus = true
        }
    }
    
    //MARK: - FaceID Usage
    func getBioMetricStatus() -> Bool {
        let scannerFace = LAContext()
        
        return scannerFace.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: .none)
    }
    
    //MARK: - FaceID Login
    func authenticationUser() async throws {
        let status = try await LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To Log in Into App")
        
        //1
        /*
         if status {
             try await loginUserFireBase(useFaceID: useFaceID, email: self.faceIDEmail, password: self.faceIDPassword)
             // eto dlya togo chtob uje vojti s soxronennimi danimi
         }
         */
        //2
        if let emailData = storedEmail, let passwordData = storedPassword, status {
            try await loginUserFireBase(useFaceID: useFaceID , email: String(data: emailData, encoding: .utf8) ?? "" , password: String(data: passwordData, encoding: .utf8) ?? "")
        }
    }
    
}
