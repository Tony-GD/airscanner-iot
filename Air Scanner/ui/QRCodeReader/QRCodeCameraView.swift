//
//  QRCodeCameraView.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 17.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import SwiftUI

struct QRCodeCameraView: UIViewControllerRepresentable {
    
    @Binding var isDisplayed: Bool
    @Binding var token: String
    
    func makeUIViewController(context: Context) -> QRCodeReaderViewController {
        return QRCodeReaderViewController()
    }
    
    func updateUIViewController(_ uiViewController:  QRCodeReaderViewController, context: Context) {
        uiViewController.completion = { token in
            self.token = token
            self.isDisplayed = false
        }
    }
}
