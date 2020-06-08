//
//  Utils.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 08.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import SwiftUI

extension Color {
    static let background = Color(UIColor(named: "Background")!)
    static let mainButton = Color(UIColor(named: "MainButton")!)
    static let mainButtonPressed = Color(UIColor(named: "MainButtonPressed")!)
}


struct MainButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(configuration.isPressed ? Color.mainButtonPressed : Color.mainButton)
            .overlay(
                configuration
                    .label
                    .font(Font.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            )
    }
}
