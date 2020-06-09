//
//  DevicesView.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 09.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import SwiftUI

struct DevicesView: View {
    
    @EnvironmentObject var localStorage: LocalStorage
    
    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
        }.overlay(
            ZStack {
                if localStorage.user == nil {
                    LoginView()
                        .transition(.opacity)
                        .zIndex(0)
                }
            }
        )
    }
}

struct DevicesView_Previews: PreviewProvider {
    static var previews: some View {
        DevicesView()
    }
}
