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
    func generate(prompts: [PromptKeyword]) async -> String?
}

class ImageGeneratorService: ImageGeneratable {
    private var llmType: LLMType
    private var client: LLMClient

    init(client: LLMClient, type: LLMType = .openai) {
        self.client = client
        self.llmType = type
    }

    public func generate(prompts: [PromptKeyword]) async -> String? {
        let keywordString = prompts.map({ $0.value }).joined(separator: ", ")
        let prompt =
            "Generate an illustration based on the following keywords: \(keywordString)"
        let result = await client.makeRequest(prompt: prompt)

        guard result.error == false, let response = result.data else {
            return nil
        }
        
        guard let image = response.data[0]["b64_json"] else { return nil }
        return image
    }

}
