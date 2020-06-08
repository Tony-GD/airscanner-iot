//
//  UIView+.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 08.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import UIKit

extension UIView {
    func clipToSuperview(insets: UIEdgeInsets = .zero) {
        guard let sv = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: sv.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: sv.trailingAnchor, constant: -insets.right),
            topAnchor.constraint(equalTo: sv.topAnchor, constant: insets.top),
            bottomAnchor.constraint(equalTo: sv.bottomAnchor, constant: -insets.bottom)
        ])
    }
}
