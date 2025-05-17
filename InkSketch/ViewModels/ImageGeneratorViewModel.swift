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

    init(service: ImageGeneratable) {
        self.service = service
    }

    func generateImage(prompts: [PromptKeyword]) {
        currentTask?.cancel()
        isProcessing = true
        currentTask = Task {
            defer { isProcessing = false }
            guard let encodedImage = await service.generate(prompts: prompts)
            else {
                print("Failed to generate image")
                return
            }
    
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
