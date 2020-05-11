//
//  SplashView.swift
//  Air Scanner
//
//  Created by User on 06.05.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject var auth: AppAuth
    var body: some View {
        Group {
            if auth.user == EmptyUser {
                GreetingView()
            } else {
                MainView()
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
