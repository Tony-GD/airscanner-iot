//
//  QRCodeCameraView.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 17.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import SwiftUI

struct QRCodeCameraView: UIViewControllerRepresentable {
    
    var completion: (String) -> ()
    
    
    func makeUIViewController(context: Context) -> QRCodeReaderViewController {
        return QRCodeReaderViewController()
    }
    
    func updateUIViewController(_ uiViewController:  QRCodeReaderViewController, context: Context) {
        uiViewController.completion = completion
    }
}
