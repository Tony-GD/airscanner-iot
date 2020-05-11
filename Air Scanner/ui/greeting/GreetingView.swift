//
//  SignInView.swift
//  Air Scanner
//
//  Created by User on 29.04.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import SwiftUI
import GoogleSignIn

struct GreetingView: View {
    @EnvironmentObject var auth: AppAuth
    
    var body: some View {
        NavigationView {
        VStack {
            Spacer()
            Image("gd_logo")
            Button(action: {
                self.openSignIn()
                
            },
                   label: {
                    Text("Sign In")
            })
            Spacer()
            Text("or")
            
            NavigationLink(destination: MainView()) {Text("Continue as guest")}
            
            Spacer()
        }
        }
    }
    
    func onSignInSuccess(user: User) {
        auth.$user.append(user)
    }
    
    func onSignInFail() {
        
    }
    
    func openSignIn() {
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
        GIDSignIn.sharedInstance()?.signIn()
    }
}

struct GreetingView_Previews: PreviewProvider {
    static var previews: some View {
        GreetingView()
    }
}
