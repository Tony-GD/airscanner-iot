//
//  QRCodeReaderView.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 17.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import SwiftUI

struct QRCodeReaderView: View {
    @Binding var isDisplayed: Bool
    @Binding var token: String
    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
            QRCodeCameraView(isDisplayed: $isDisplayed, token: $token)
        }.navigationBarTitle("QR Code", displayMode: .inline)
    }
}
