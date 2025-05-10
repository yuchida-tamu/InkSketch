//
//  Item.swift
//  InkSketch
//
//  Created by Yuta Uchida on 2025/05/10.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
