//
//  ImageGeneraterControl.swift
//  InkSketch
//
//  Created by Yuta Uchida on 2025/05/18.
//

import SwiftUI

struct ImageGeneraterControl: View {
    var body: some View {
        HStack(spacing: 8){
            Spacer()
            Image(systemName: "pencil")
                
        }
        .frame(maxWidth: .infinity)
        
    }
}

#Preview {
    ImageGeneraterControl()
        .padding()
}
