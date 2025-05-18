//
//  Sketch.swift
//  InkSketch
//
//  Created by Yuta Uchida on 2025/05/18.
//
import SwiftData
import Foundation

@Model
class Sketch {
    var id = UUID()
    var data: String
    
    init(data: String) {
        self.data = data
    }
}
