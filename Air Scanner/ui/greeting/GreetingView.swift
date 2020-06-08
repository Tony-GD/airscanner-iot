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
        ZStack {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
            VStack {
                Spacer()
                VStack {
                    Button(action: { self.openSignIn() }) {
                        Text("Log In")
                    }
                    .frame(width: 258.0, height: 40.0)
                    .buttonStyle(MainButtonStyle())
                    .padding()
                    Text("by")
                        .font(.system(size: 10))
                        .foregroundColor(Color.white)
                    Image("gd_logo_small")
                }
                .padding(.bottom, 40)
            }
            Color.clear
        }
        .background(Color.background)
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
