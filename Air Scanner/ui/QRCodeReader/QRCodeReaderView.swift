//
//  QRCodeReaderView.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 17.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import SwiftUI

struct QRCodeReaderView: View {
    var completion: (String) -> ()
    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
            QRCodeCameraView(completion: completion)
        }.navigationBarTitle("QR Code", displayMode: .inline)
    }
}
