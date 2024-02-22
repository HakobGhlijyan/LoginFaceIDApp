//
//  DesignUIExtension.swift
//  LoginFaceIDApp
//
//  Created by Hakob Ghlijyan on 21.02.2024.
//

import SwiftUI

//MARK: - Extension for UI Designin
extension View {
    func hLeading() -> some View { self.frame(maxWidth: .infinity, alignment: .leading) }
    func hTrailing() -> some View { self.frame(maxWidth: .infinity, alignment: .trailing) }
    func hCenter() -> some View { self.frame(maxWidth: .infinity, alignment: .center) }
}

struct TFStyleViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
    }
}

struct ButtonStyleViewModifier: ViewModifier {
    let isDisabled: Bool
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .foregroundStyle(.white)
            .bold()
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(LinearGradient(
                colors: isDisabled ? [Color.gray.opacity(0.3)] : [Color.orange, Color.blue.opacity(0.3)] ,
                startPoint: .bottomLeading,
                endPoint: .topTrailing))
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .disabled(isDisabled)
    }
}

extension View {
    func customTFStyle() -> some View {
        modifier(TFStyleViewModifier())
    }
    func customButtonStyle(isDisabled:Bool) -> some View {
        modifier(ButtonStyleViewModifier(isDisabled: isDisabled))
    }
}

struct ButtonView: View {
    let isDisabled: Bool
    let action: () -> ()
    
    var body: some View {
        Button(action: action) {
            Text("Sign In")
        }
        .customButtonStyle(isDisabled: isDisabled)
    }
}

