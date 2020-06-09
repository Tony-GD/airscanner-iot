//
//  LoginView.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 09.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import SwiftUI
import GoogleSignIn

struct LoginView: View {
    
    @Environment(\.window) var window: UIWindow?
    
    @State var isLoading = false
    
    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
            VStack(spacing: 32) {
                Image("login")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Text("Please Log In via Gmail SSO account to have possibility to manage personal devices and recieve notifications.")
                    .font(.system(size: 15))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Button(action: {
                    self.isLoading.toggle()
                    self.showLogin()
                }) {
                    ZStack {
                        if !self.isLoading {
                            Text("Sign In")
                        }
                        LoadingIndicator(isLoading: self.isLoading, color: .white)
                    }
                }
                    .buttonStyle(MainButtonStyle())
                    .disabled(self.isLoading)
                    .frame(width: 258, height: 40)
                    .padding(.top, 30)
            }
            .padding([.leading, .trailing], 50)
        }
    }
    
    func showLogin() {
        GIDSignIn.sharedInstance()?.presentingViewController = window!.rootViewController
        GIDSignIn.sharedInstance()?.signIn()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
