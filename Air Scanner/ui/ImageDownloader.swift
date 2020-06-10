//
//  ImageDownloader.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 10.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import Foundation
import Kingfisher
import Combine

final class ImageDownloader: ObservableObject {
    var url: URL?
    @Published var image: UIImage?
    
    init(url: URL?) {
        self.url = url
        downloadImage()
    }
    
    func downloadImage() {
        guard let url = self.url else {
            return
        }
        KingfisherManager.shared.retrieveImage(with: url) { result in
            DispatchQueue.main.async {
                self.image = (try? result.get())?.image
            }
        }
    }
}
