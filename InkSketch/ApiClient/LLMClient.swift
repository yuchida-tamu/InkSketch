//
//  LLMClient.swift
//  InkSketch
//
//  Created by Yuta Uchida on 2025/05/11.
//

import Foundation

protocol LLMClient {
    func makeRequest(prompt: String) async -> LLMResult
}

protocol LLMModel {
    var model: String { get set }
}

struct LLMResult {
    var error: Bool = false
    var data: LLMImageData?
}

struct LLMImageData: Codable {
    var created: Int
    var data: [[String: String]]
}
