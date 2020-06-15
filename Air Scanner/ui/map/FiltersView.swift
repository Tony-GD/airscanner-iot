//
//  FiltersView.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 15.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import SwiftUI

struct FiltersView: View {
    @EnvironmentObject private var storage: MapDevicesStorage
    @Binding var showFilters: Bool
    private let metrics: [PublicMetric?] = [nil] + PublicMetric.allCases
    var body: some View {
        ZStack {
            Color.mainButton.edgesIgnoringSafeArea(.all)
            List {
                ForEach(Array(metrics.enumerated()), id: \.offset) { metric in
                    Button(action: {
                        self.storage.updateFilter(metric.element)
                        withAnimation {
                            self.showFilters = false
                        }
                    }) {
                        FilterCell(metric: metric.element, selected: metric.element == self.storage.filter)
                    }
                }
            }
        }
    }
}

struct FiltersView_Previews: PreviewProvider {
    @State static var showFilters: Bool = false
    static var previews: some View {
        FiltersView(showFilters: $showFilters)
    }
}
