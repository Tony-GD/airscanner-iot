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
            
            NavigationLink(destination: ContentView()) {Text("Continue as guest")}
            
            Spacer()
        }
        }
    }
    
    func onSignInSuccess() {
        
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
