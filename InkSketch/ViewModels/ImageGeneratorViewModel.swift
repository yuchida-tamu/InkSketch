//
//  ImageGeneratorViewModel.swift
//  InkSketch
//
//  Created by Yuta Uchida on 2025/05/17.
//

import Foundation
import SwiftUI

@Observable class ImageGeneratorViewModel {
    private var currentTask: Task<(), Never>?
    private var service: ImageGeneratable
    
    var isProcessing = false
    var uiImage: UIImage?
    var encodedImageData: String?

    init(service: ImageGeneratable) {
        self.service = service
    }

    func generateImage(motif: String, keywords: String) {
        currentTask?.cancel()
        isProcessing = true
        currentTask = Task {
            defer { isProcessing = false }
            guard let encodedImage = await service.generate(motif: motif, keywords: keywords)
            else {
                print("Failed to generate image")
                return
            }
            
            encodedImageData = encodedImage
    
            // Convert base64 image string into Data
            guard let imageData = Data(base64Encoded: encodedImage) else {
                print("Failed to decode image data")
                return
            }

            uiImage = UIImage(data: imageData)
        }
    }

    func initTask() {
        currentTask?.cancel()
    }

    struct ImagePayload: Decodable {
        let image: String
    }
}
