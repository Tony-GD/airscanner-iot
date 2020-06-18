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
-----BEGIN PRIVATE KEY-----
MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDGmi/JHuEnT7Ma
vgFDVxARTblGI7ie7DU9BF1rVWj/HlcIFqsqUG+33bwUXhqXWZnGm6Y1SoFG9SU4
enWFonWIHGsBW1MZ5DSi8HQOzuM2HlyPy/qaIRAfNKruULsiuuQ1HZIpSJiaco83
X6SD4MSySt3voNT91EL9Lm4XXm4atuwNy4DNoGWnRJpFSPq55Y2Gl+DVE4gO3YmN
xgyaNxVpCNWFomMJW+Rf+NyU3CVl0NyQsFP8nDSiF+Gwbj/DeNYh4rIcdVECjdqd
xHODbP4VakFrX/MThWvV83oA54cHT1b3o8jk2hGUQaxtxKhkgTxcGKmFbPV26ldF
j0DPMKfnAgMBAAECggEAZRQWXAs+Vq6mnmaz590IzXW8ZSlLDn9zvSFaloU60hVU
AEbhSMD1iyPsVIVsjTlKHZ4cYqUP1Nhx4CPbam872FF2WJNtYREXhRJSTzMWyvV6
8KjFW+qV9PvuPyqRg+SQv0PUnvRWzsydfXZNGd2s3n1iJVK69JEyov8dgwFJkog+
7d2S6xo6U+ufV3pj/3opjqCkBN5RPiH1ityjsUcuZEIN++k+vwms6BvU19zIvbEk
nAutkmL7D3f8K1doYohdzUcy5ZNa7E8C0NbHrqFRy3LAgs5/3Eid6SCdEpjsfUgu
+KGdqWYF1jND61lV/85VRvdxXAw3A+mlj+glRZCQeQKBgQDwhmUS2KCf3by5kW0U
5ucKaNSPedmOfvMOhimi3kdEpjDHZ55lDJnRoNBRGsLfbANzxRN8TrGHvIjv3lkF
qyILTCRj02dqBSrzZorj1hOC0UhYcpfkOBcCusmjDDZbJvsTMyaEKh+nuu55To5i
Y4NF3oSA6iZU3I+0uBpSWE2cuwKBgQDTYUwo3IPDnypDfKOqvjOL1jEkak4mz4Jw
zOFiVBBr5IqgtdFgyRwWEGCafdrLS3Us1Dy3RmRUG9Xw9WIvthPo4qUjWmPloE/e
Qpg6fylLZhz7pgOac7EycGAEGzaGJ+axvoN/ktfz6bnIcTW50Zav8IWYvBUH7Eea
35D3idpkxQKBgFNzLYo2YrRUqG/xxtjjq/FuoaEN869+2DGH1tZNLIji6DWm+8uv
bYbPtrcNA+OkhCYckEAmxW2EujYO/O/8ihlFV7LS3CRqmpZMU4/s7GQM3H7jc1OZ
KlKmH+NUD1/czGvC6XAddVIqhybLXJdCU39gTrSziI0U4T8gSPGc9YCVAoGAGgQF
nZnWVcNHLlsuwZr7OSC5l6PFzp0Hjt6IdtOl2cGdFj6KcIEQBd8qJJmMziyRVV0h
w+TUAE4UvL1WwkyEkssiTAGZ/e8HJXHIzppL+M2uj4JVOzM2AeE20AqRYV2T1Rh/
krn9/jUr+nGEjUQwaaMOrkenxvvbrEIL04uR54kCgYAkboAa1kn/lk0c8vEPxtjg
Egj2ciFmnpwkm+Gu71e1XXpQFZbmQNLWmS7PzdrRJRAanuOuLaCAGHSwD5HK9ViM
OOE3wNX+A5Ci3gkEs+lSBWo0t7ISDyogUAoAuxqyBE/nAp0HBAxSr5DWKVB4RDlL
ri418OlO5yhxEcZg2MZHjg==
-----END PRIVATE KEY-----
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
        label.font = .systemFont(ofSize: 83)
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
