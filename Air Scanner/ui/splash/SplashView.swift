//
//  SplashView.swift
//  Air Scanner
//
//  Created by User on 06.05.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import SwiftUI



struct SplashView: View {
    @State var isActive: Bool
    var body: some View {
        NavigationView {
            NavigationLink(destination: ContentView(), isActive: $isActive) {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
