//
//  PinView.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 15.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import UIKit

class PinView: UIView {
    
    private var imageView: UIImageView
    private var device: Device?

    
    override init(frame: CGRect) {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "pin"))
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        
        self.imageView = imageView
        
        super.init(frame: frame)
        backgroundColor = .clear
        
        addSubview(imageView)
        imageView.clipToSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with device: Device) {
        self.device = device
    }
}
