//
//  OpenAIClient.swift
//  InkSketch
//
//  Created by Yuta Uchida on 2025/05/11.
//

import Foundation

class OpenAIModel: LLMModel {
    private enum ImageModel: String {
        case gptImage = "gpt-image-1"
        case dalle2 = "dall-e-2"
        case dalle3 = "dall-e-3"
    }
    private var _model = ImageModel.gptImage

    var model: String {
        get {
            return _model.rawValue
        }

        set {
            if let m = ImageModel(rawValue: newValue) {
                _model = m
            } else {
                _model = .gptImage
            }
        }
    }
}

class OpenAIClient: LLMClient {
    private var model: LLMModel
    private var keyManager: APIKeyManager
    private var url = URL(
        string: "https://api.openai.com/v1/images/generations")
    private var decoder = JSONDecoder()

    init(keyManager: APIKeyManager, model: LLMModel) {
        self.keyManager = keyManager
        self.model = model
    }

    public func makeRequest(prompt: String) async -> LLMResult {
        guard let request = getRequest(prompt: prompt) else {
            return LLMResult(error: true)
        }

        do {
            let (data, response) = try await URLSession.shared.data(
                for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                return LLMResult(error: true)
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                print("Request Failed: \(httpResponse.statusCode)")
                print("Response: \(String(describing: data))")
                return LLMResult(error: true)
            }
            
            guard let decoded = decodeData(data: data) else {
                print("Decoding Feild")
                return LLMResult(error: true)
            }

            return LLMResult(error: false, data: decoded)
        } catch {
            return LLMResult(error: true, data: nil)
        }
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
                model: self.model.model, prompt: prompt)
            return try JSONEncoder().encode(requestBody)
        } catch {
            return nil
        }
    }
    
    private func decodeData(data: Data) -> LLMImageData? {
        do {
            let json = try decoder.decode(LLMImageData.self, from: data)
            return json
        } catch {
            return nil
        }
    }

    struct RequestBody: Codable {
        var model: String
        var prompt: String
        var response_format: String = "b64_json"
        var size: String = "512x512"
    }

}
