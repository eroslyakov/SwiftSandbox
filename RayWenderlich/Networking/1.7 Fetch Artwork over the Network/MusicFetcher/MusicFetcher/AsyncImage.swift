//
//  AsyncImage.swift
//  MusicFetcher
//
//  Created by Rosliakov Evgenii on 08.09.2021.
//  Copyright © 2021 raywenderlich. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct AsyncImage: View {
    @StateObject private var imageLoader: ImageLoader
    
    init(url: String) {
        _imageLoader = StateObject(wrappedValue: ImageLoader(url: url))
    }
    
    var body: some View {
        content
            .onAppear(perform: imageLoader.load)
    }
    
    var content: some View {
        Group {
            if imageLoader.image != nil {
                Image(uiImage: imageLoader.image!)
                    .resizable()
            } else {
                VStack {}
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
            }
        }
    }
}
