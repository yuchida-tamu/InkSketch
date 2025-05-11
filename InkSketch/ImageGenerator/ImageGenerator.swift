//
//  ImageGenerator.swift
//  InkSketch
//
//  Created by Yuta Uchida on 2025/05/10.
//

import Foundation

protocol LLMResonse: Codable, Decodable {}

struct OpenAIImageResponse: LLMResonse {
    var created: Int
    var data: [[String : String]]
}

enum LLMType {
    case openai
}

protocol ImageGeneratable {
    func generateUrl(prompts: [PromptKeyword]) async -> String?
}

class ImageGenerator: ImageGeneratable {
    private static let responseContainer: [ LLMType : LLMResonse.Type ] = [
        .openai: OpenAIImageResponse.self
    ]
    private var llmType: LLMType
    private var client: LLMClient

    init(client: LLMClient, type: LLMType = .openai) {
        self.client = client
        self.llmType = type
    }
    
    public func generateUrl(prompts: [PromptKeyword]) async -> String? {
        let keywordString = prompts.map({ $0.value }).joined(separator: ", ")
        let prompt =
            "Generate an illustration based on the following keywords: \(keywordString)"
        guard let (data, response) = await client.makeRequest(prompt: prompt)
        else {
            return nil
        }

        guard (200...299).contains(response.statusCode) else {
            print("Request Failed: \(response.statusCode)")
            print("Response: \(String(describing: data))")
            return nil
        }

        do {
            let decoder = JSONDecoder()
            
            guard let responseType = ImageGenerator.responseContainer[llmType] else { return nil }
            
            let result  = try decoder.decode(responseType, from: data) as? OpenAIImageResponse
            guard let url = result?.data[0]["url"] else {
                return nil
            }

            return url
        } catch let error {
            print("something went wrong \(error)")
            return nil
        }
    }
}
