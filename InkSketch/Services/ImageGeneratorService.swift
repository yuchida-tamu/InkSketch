//
//  ImageGenerator.swift
//  InkSketch
//
//  Created by Yuta Uchida on 2025/05/10.
//

import Foundation

enum LLMType {
    case openai
}

protocol ImageGeneratable {
    func generate(motif: String, keywords: String) async -> String?
}

class ImageGeneratorService: ImageGeneratable {
    private var llmType: LLMType
    private var client: LLMClient

    init(client: LLMClient, type: LLMType = .openai) {
        self.client = client
        self.llmType = type
    }

    public func generate(motif: String, keywords: String) async -> String? {
        let prompt = "A detailed black and white tattoo design of \(motif), with clean, crisp line work and high contrast. The style is minimal. The design should be clear and suitable as a tattoo stencil. Include elements like \(keywords) if applicable. The composition should be balanced, focused on the main subject, and drawn with precise outlines. No background shading. No color."

        let result = await client.makeRequest(prompt: prompt)

        guard result.error == false, let response = result.data else {
            return nil
        }
        
        guard let image = response.data[0]["b64_json"] else { return nil }
        return image
    }

}
