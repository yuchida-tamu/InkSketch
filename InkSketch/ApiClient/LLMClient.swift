//
//  LLMClient.swift
//  InkSketch
//
//  Created by Yuta Uchida on 2025/05/11.
//

import Foundation

protocol LLMClient {
    func makeRequest(prompt: String) async -> (Data, HTTPURLResponse)?
}

protocol LLMModel {
    var model: String { get set }
}
