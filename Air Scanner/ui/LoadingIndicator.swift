//
//  LoadingIndicator.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 09.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import SwiftUI

struct LoadingIndicator: UIViewRepresentable {
    
    var isLoading: Bool
    var color: UIColor
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.color = color
        loadingIndicator.hidesWhenStopped = true
        return loadingIndicator
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        if isLoading && !uiView.isAnimating {
            uiView.startAnimating()
        } else if !isLoading && uiView.isAnimating {
            uiView.stopAnimating()
        }
    }
}

struct LoadingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        LoadingIndicator(isLoading: false, color: .white)
    }
}
