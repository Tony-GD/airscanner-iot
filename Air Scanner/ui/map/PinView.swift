//
//  PinView.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 15.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import UIKit
import Combine

class PinView: UIView {
    
    private var label: UILabel
    private var bgView: UIView
    private var device: Device?
    
    private var token: AnyCancellable?
    private var displayedMetric: PublicMetric?
    
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
        label.font = .systemFont(ofSize: 9, weight: .semibold)
        label.textColor = .black
        
        self.label = label
        self.bgView = bgView
        
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
    
    func configure(with device: Device, displayedMetric: PublicMetric?) {
        self.device = device
        self.displayedMetric = displayedMetric
        token?.cancel()
        token = device.$metrics.sink { value in
            self.updateValue(metrics: value, animated: true)
        }
    }
    
    private func updateValue(metrics: [String: Metric], animated: Bool = false) {
        guard let metric = displayedMetric else {
            label.text = nil
            return
        }
        let value = device?.value(for: metric, metrics: metrics).flatMap { Formatters.numberFormatter.string(from: NSNumber(value: $0)) }
        guard animated && value != nil && label.text != nil else {
            label.text = value
            return
        }
        
        UIView.animate(withDuration: 0.15, animations: {
            self.bgView.backgroundColor = .orange
            self.label.text = value
        }) { _ in
            UIView.animate(withDuration: 0.15) {
                self.bgView.backgroundColor = .white
            }
        }
    }
    
}
