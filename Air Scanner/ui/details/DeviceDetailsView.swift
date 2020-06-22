//
//  DeviceDetailsView.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 22.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import SwiftUI

struct DeviceDetailsView: View {
    var device: Device
    var body: some View {
        ZStack {
            Color.background
        }.navigationBarTitle("\(device.displayName)")
    }
}
