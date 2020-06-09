//
//  Utils.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 08.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import SwiftUI

struct EnvironmentWindowKey: EnvironmentKey {
    static var defaultValue: UIWindow? = nil
}

extension EnvironmentValues {
    var window: UIWindow? {
        get {
            self[EnvironmentWindowKey.self]
        }
        
        set {
            self[EnvironmentWindowKey.self] = newValue
        }
    }
}

extension Color {
    static let background = Color("Background")
    static let mainButton = Color("MainButton")
    static let mainButtonPressed = Color("MainButtonPressed")
    static let darkText = Color("DarkText")
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
