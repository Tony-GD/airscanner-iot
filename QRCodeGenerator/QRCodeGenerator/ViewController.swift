//
//  ViewController.swift
//  QRCodeGenerator
//
//  Created by Alexandr Gaidukov on 17.06.2020.
//  Copyright © 2020 Alexaner Gaidukov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    
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
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = generateQRCode(from: testPublicKey)
    }


}

