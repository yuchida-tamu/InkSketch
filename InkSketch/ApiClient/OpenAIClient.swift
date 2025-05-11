//
//  OpenAIClient.swift
//  InkSketch
//
//  Created by Yuta Uchida on 2025/05/11.
//

import Foundation

enum OpenAIImageModel: String {
    case gptImage = "gpt-image-1"
    case dalle2 = "dall-e-2"
    case dalle3 = "dall-e-3"
}

class OpenAIClient: LLMClient {
    private var model: OpenAIImageModel = .gptImage
    private var keyManager: APIKeyManager
    private var url = URL(
        string: "https://api.openai.com/v1/images/generations")

    init(keyManager: APIKeyManager) {
        self.keyManager = keyManager
    }

    public func makeRequest(prompt: String) async -> (Data, HTTPURLResponse)? {
        guard let request = getRequest(prompt: prompt) else { return nil }

        do {
            let (data, response) = try await URLSession.shared.data(
                for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                return nil
            }

            return (data, httpResponse)
        } catch {
            return nil
        }
    }

    public func setModel(_ model: OpenAIImageModel) {
        self.model = model
    }

    private func getRequest(prompt: String) -> URLRequest? {
        guard let url = self.url,
            let apiKey = keyManager.apiKey(for: "OPEN_AI_API_KEY")
        else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(
            "Bearer \(apiKey)",
            forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = getRequestBody(prompt: prompt)

        return request
    }

    private func getRequestBody(prompt: String) -> Data? {
        do {
            let requestBody = RequestBody(
                model: self.model.rawValue, prompt: prompt)
            return try JSONEncoder().encode(requestBody)
        } catch {
            return nil
        }
    }

    struct RequestBody: Codable {
        var model: String
        var prompt: String
    }

}
