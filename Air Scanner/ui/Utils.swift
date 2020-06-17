//
//  Utils.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 08.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import SwiftUI


struct Formatters {
    static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        return formatter
    }()
}

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
    static let inputBackground = Color("InputBackground")
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

struct DisclosureButtonStyle: ButtonStyle {
    
    enum DisclosureChevronDirection: String {
        case right
        case up
        case down
        
        var imageName: String {
            return "chevron." + rawValue
        }
    }
    
    var direction: DisclosureChevronDirection = .right
    
    func makeBody(configuration: Configuration) -> some View {
        RoundedRectangle(cornerRadius: 2)
        .fill()
        .overlay(
            HStack {
                configuration
                    .label
                Spacer()
                Image(systemName: direction.imageName)
            }
            .font(Font.system(size: 14))
            .foregroundColor(.white)
            .padding(.horizontal, 12)
        )
    }
}

struct GhostButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        RoundedRectangle(cornerRadius: 2)
        .stroke(lineWidth: 1)
            .foregroundColor(Color.white.opacity(0.6))
            .background(configuration.isPressed ? Color.white.opacity(0.6) : Color.white.opacity(0.001))
        .cornerRadius(2)
        .overlay(
            configuration
                .label
                .font(Font.system(size: 16, weight: .semibold))
                .foregroundColor(configuration.isPressed ? .background : .white)
        )
    }
}

struct MainTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 12)
            .frame(height: 36)
            .font(.system(size: 14))
            .foregroundColor(.white)
            .background(Color.inputBackground)
            .cornerRadius(2)
    }
}
