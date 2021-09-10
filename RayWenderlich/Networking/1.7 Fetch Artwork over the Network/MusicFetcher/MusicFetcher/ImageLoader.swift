//
//  ImageLoader.swift
//  MusicFetcher
//
//  Created by Rosliakov Evgenii on 10.09.2021.
//  Copyright © 2021 raywenderlich. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class ImageLoader: ObservableObject {
    @Published public var image: UIImage?
    private let url: String
    private var cancellable: AnyCancellable?
    
    init(url: String) {
        self.url = url
    }
    
    deinit {
        cancel()
    }
    
    public func load() {
        guard let url = URL(string: url) else {
            return
        }
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { print("completed for \(self.url): \($0)") },
                  receiveValue: { [weak self] in self?.image = $0 })
    }
    
    private func cancel() {
        cancellable?.cancel()
    }
}

