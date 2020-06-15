//
//  PinView.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 15.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import UIKit

class PinView: UIView {
    
    private var label: UILabel
    
    override init(frame: CGRect) {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Pin"))
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        
        let bgView = UIView(frame: .zero)
        bgView.backgroundColor = .white
        bgView.clipsToBounds = true
        bgView.layer.cornerRadius = 13
        
        let label = UILabel(frame: .zero)
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 10, weight: .semibold)
        label.textColor = .black
        
        self.label = label
        
        super.init(frame: frame)
        backgroundColor = .clear
        
        addSubview(bgView)
        bgView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: topAnchor, constant: 5.0),
            bgView.widthAnchor.constraint(equalToConstant: 26.0),
            bgView.heightAnchor.constraint(equalToConstant: 26.0),
            bgView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        addSubview(imageView)
        imageView.clipToSuperview()
        
        bgView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: bgView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: bgView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with value: String) {
        label.text = value
    }
    
}
