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
    @EnvironmentObject var localStorage: LocalStorage
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.background.edgesIgnoringSafeArea(.all)
            VStack {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text("by Grid Dynamics")
                    .font(.system(size: 12))
                    .foregroundColor(.darkText)
            }
            .frame(width: 100)
            .padding([.leading, .top], 20)
            VStack(alignment: .center, spacing: 32) {
                Spacer()
                
                Text("Hello!")
                    .font(.system(size: 25, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Grid Dynamics has been engaged in technology thought leadership activities by attending industry conferences, organizing emerging technology meetup events and judging and hosting community robotics competitions, hackathons and workshops.")
                    .font(.system(size: 15))
                    .foregroundColor(.white)
                    .lineLimit(nil)
                    .padding([.leading, .trailing], 50)
                
                Button(action: {
                    withAnimation {
                        self.localStorage.greetingShown = true
                    }
                }) {
                    Text("Let's go!")
                }
                .buttonStyle(MainButtonStyle())
                .frame(width: 258, height: 40)
                .padding(.top, 15)
                
                Spacer()
            }
        }
    }
}

struct GreetingView_Previews: PreviewProvider {
    static var previews: some View {
        GreetingView()
    }
}
