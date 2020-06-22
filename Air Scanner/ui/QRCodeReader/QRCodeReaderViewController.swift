//
//  QRCodeReaderViewController.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 17.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeReaderViewController: UIViewController {
    
    var completion: (String) -> () = { _ in }
    
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    private let testPublicKey = """
-----BEGIN CERTIFICATE-----
MIIDAzCCAeugAwIBAgIUCFTeDPAXzUUgsN9ZN7Mk/msHZO0wDQYJKoZIhvcNAQEL
BQAwETEPMA0GA1UEAwwGdW51c2VkMB4XDTIwMDYxNzExMzI0N1oXDTIwMDcxNzEx
MzI0N1owETEPMA0GA1UEAwwGdW51c2VkMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
MIIBCgKCAQEAxpovyR7hJ0+zGr4BQ1cQEU25RiO4nuw1PQRda1Vo/x5XCBarKlBv
t928FF4al1mZxpumNUqBRvUlOHp1haJ1iBxrAVtTGeQ0ovB0Ds7jNh5cj8v6miEQ
HzSq7lC7IrrkNR2SKUiYmnKPN1+kg+DEskrd76DU/dRC/S5uF15uGrbsDcuAzaBl
p0SaRUj6ueWNhpfg1ROIDt2JjcYMmjcVaQjVhaJjCVvkX/jclNwlZdDckLBT/Jw0
ohfhsG4/w3jWIeKyHHVRAo3ancRzg2z+FWpBa1/zE4Vr1fN6AOeHB09W96PI5NoR
lEGsbcSoZIE8XBiphWz1dupXRY9AzzCn5wIDAQABo1MwUTAdBgNVHQ4EFgQU+AtF
lVqFXq8ngh2E/bjrK+DEINIwHwYDVR0jBBgwFoAU+AtFlVqFXq8ngh2E/bjrK+DE
INIwDwYDVR0TAQH/BAUwAwEB/zANBgkqhkiG9w0BAQsFAAOCAQEAbnVSJ0uSWM3r
utX7jpd+VFZBABSidA15Hydn6bJ/4kDFehu958OEJKTBfz9Hph5+2EGO1WccA2Qs
WkXrtLRQ/NeqYucT5Dqx0CdTK+rNXD0Y1qYIKufr7JhPj2MtXuxsord10Xz7PppA
F90pX94u5/l45r1bT5H8UGGEqXP9xryxwQj1CHYXwB5MtRKVyCfJqF1ElYgYzS/Q
p/TArR55fdQVoOwiErbqbGhrx9CdVqc4M/LM7sAIpswO74eHECaY9coPDkUVu0kC
SwPAk5nQ7J93oKXc7OTJKDJXxgo/20PTan8vPYDV01mIFRYhdrbWMR46sqCPtxJi
8vwVvdnjaQ==
-----END CERTIFICATE-----
"""
    
    private var videoOrientation: AVCaptureVideoOrientation? {
        let interfaceOrientation = UIApplication.shared.windows.first(where: { $0.isKeyWindow })!.windowScene!.interfaceOrientation
        switch interfaceOrientation {
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        case .portrait:
            return .portrait
        case .portraitUpsideDown:
            return .portraitUpsideDown
        case .unknown:
            return nil
        @unknown default:
            return nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            failed()
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            failed()
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        if let videoOrientation = videoOrientation {
            previewLayer.connection?.videoOrientation = videoOrientation
        }
        view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if captureSession?.isRunning == false {
            captureSession?.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if captureSession?.isRunning == true {
            captureSession?.stopRunning()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.bounds
        if let videoOrientation = videoOrientation {
            previewLayer?.connection?.videoOrientation = videoOrientation
        }
    }
    
    private func failed() {
        captureSession = nil
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .systemFont(ofSize: 8)
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.text = testPublicKey
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(named: "MainButton")
        button.setTitle("Select", for: .normal)
        button.layer.cornerRadius = 2.0
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.addTarget(self, action: #selector(selectTapped), for: .touchUpInside)
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            button.widthAnchor.constraint(equalToConstant: 258),
            button.heightAnchor.constraint(equalToConstant: 40),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func selectTapped() {
        completion(testPublicKey)
    }
}

extension QRCodeReaderViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession?.stopRunning()
        
        if let metadataObject = metadataObjects.first,
            let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
            let stringValue = readableObject.stringValue {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            DispatchQueue.main.async {
                self.completion(stringValue)
            }
        } else {
            captureSession.startRunning()
        }
    }
}
