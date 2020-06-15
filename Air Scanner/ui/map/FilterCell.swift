//
//  FilterCell.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 15.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import SwiftUI

struct FilterCell: View {
    
    var metric: PublicMetric?
    var selected: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 2.0)
                .frame(width: 16, height: 16)
                .overlay(
                    ZStack {
                        if selected {
                            RoundedRectangle(cornerRadius: 6)
                                .fill()
                                .frame(width: 12, height: 12)
                        }
                    }
            ).foregroundColor(.white)
            Text(metric?.rawValue ?? "All Sensors")
                .font(.system(size: 17))
                .foregroundColor(.white)
        }
        .padding()
    }
}

struct FilterCell_Previews: PreviewProvider {
    static var previews: some View {
        FilterCell(metric: nil, selected: true)
    }
}
