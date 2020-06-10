//
//  RemoteImage.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 10.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import SwiftUI

struct RemoteImage: View {
    var placeholder: Image
    @ObservedObject private var imageDownloader: ImageDownloader
    
    init(placeholder: Image, url: URL?) {
        self.placeholder = placeholder
        imageDownloader = ImageDownloader(url: url)
    }
    
    var body: some View {
        if imageDownloader.image != nil {
            return Image(uiImage: imageDownloader.image!).resizable()
        }
        return placeholder.resizable()
    }
}

struct RemoteImage_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImage(placeholder: Image(systemName: "person.fill"), url: nil)
    }
}
