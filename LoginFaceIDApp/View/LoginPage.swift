//
//  LoginPage.swift
//  LoginFaceIDApp
//
//  Created by Hakob Ghlijyan on 21.02.2024.
//

import SwiftUI

struct LoginPage: View {
    @StateObject private var viewModel: LoginViewModel = LoginViewModel()
    
    //MARK: - User Log Status
    @AppStorage("log_status") var logStatus: Bool = false
    
    //MARK: - FaceID Properties
    @AppStorage("use_face_id") var useFaceID: Bool = false
        
    //MARK: - FaceID Properties
    @State var useFaceIDforPick: Bool = false

     var body: some View {
         VStack {
             //MARK: - Logo
             logoLayer
             
             //MARK: - TextFields
             fieldsLayer

             //MARK: - User Prompt to ask to store Login using FaceID on next time
             faceIDUseLayer
             
             //MARK: - Button Log in
             buttonsLayer
             Spacer()
             //
             Text("logStatus:\(logStatus.description)")
             Text("useFaceIDforPick:\(useFaceIDforPick.description)")
             Text("useFaceID:\(useFaceID.description)")
             //
         }
         .padding(.horizontal, 25)
         .padding(.vertical)
         //MARK: - Alert
         .alert(viewModel.errorMessage, isPresented: $viewModel.showError) {
             //
         }
     }
}

#Preview {
    LoginPage()
}

extension LoginPage {
    
    private var logoLayer: some View {
        VStack {
            Circle()
                .trim(from: 0, to: 0.5)
                .fill(.black)
                .frame(width: 50, height: 50)
                .rotationEffect(.degrees(-90))
                .hLeading()
                .offset(x: -25)
                .padding(.bottom, 30)
            
            Text("Hello, \nLogin Now")
                .font(.largeTitle).bold()
                .foregroundStyle(.black)
                .hLeading()
        }
    }
    
    private var fieldsLayer: some View {
        VStack {
            //MARK: - TextFields
            TextField("Email...", text: $viewModel.email)
                .customTFStyle()
                .textInputAutocapitalization(.never)
                .padding(.top, 15)
            
            //MARK: - SecureField
            SecureField("Password...", text: $viewModel.password)
                .customTFStyle()
                .textInputAutocapitalization(.never)
                .padding(.top, 15)
        }
    }
    
    private var faceIDUseLayer: some View {
        VStack {
            if viewModel.getBioMetricStatus() {
                Group {
                    if viewModel.useFaceID {
                        Button {
                            //MARK: - Do Face id Action
                            Task {
                                do {
                                    try await viewModel.authenticationUser()
                                } catch {
                                    viewModel.errorMessage = error.localizedDescription
                                    viewModel.showError.toggle()
                                }
                            }
                        } label: {
                            VStack(alignment: .leading, spacing: 10, content: {
                                Label(
                                    title: { Text("Use FaceId to login into previous account") },
                                    icon: { Image(systemName: "faceid") }
                                )
                                .font(.caption)
                                .foregroundStyle(.red)
                                
                                Text("Note: You can turn of if in settings!")
                                    .font(.caption2)
                                    .foregroundStyle(.gray)
                            })
                        }
                        .hLeading()
                    } else {
                        Toggle(isOn: $useFaceIDforPick, label: {
                            Text("Use FaceID to Login")
                                .foregroundStyle(.gray)
                        })
                    }
                }
                .padding(.vertical, 20)
            }
        }
    }
    
    private var buttonsLayer: some View {
        VStack {
            Button(action: {
                Task {
                    do {
                        try await viewModel.loginUserFireBase(useFaceID: useFaceIDforPick)
                    } catch {
                        viewModel.errorMessage = error.localizedDescription
                        viewModel.showError = true
                    }
                }
            }, label: {
                Text("Login")
            })
            .customButtonStyle(isDisabled: viewModel.isDisabled)
            .padding(.vertical, 15)
            
            //MARK: - Button for Skip , NO LOG IN
            NavigationLink {
                //MARK: - Going home without login
            } label: {
                Text("Skip Now")
                    .foregroundStyle(.gray)
            }
        }
    }
    
}

