
//
//  SwiftUIView.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 19.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import SwiftUI

struct AlertView: View {
    
    var state: AlertState
    
    var body: some View {
        ZStack {
            Color
                .black
                .opacity(0.3)
                .edgesIgnoringSafeArea(.all)
                .zIndex(0)
            VStack {
                Spacer()
                state.image
                    .font(.system(size: 80))
                Spacer()
                VStack(spacing: 10) {
                    Text(state.title ?? "")
                        .font(.system(size: 16, weight: .bold))
                    Text(state.message ?? "")
                        .lineLimit(nil)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal, 20)
            .frame(width: 300, height: 285)
            .background(state.color)
            .cornerRadius(4)
        }
    }
}
