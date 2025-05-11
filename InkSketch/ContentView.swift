//
//  ContentView.swift
//  InkSketch
//
//  Created by Yuta Uchida on 2025/05/10.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    var body: some View {
        VStack{
            ImageGeneratorView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .environment(\.colorScheme, .dark)
        
    }
       

}

#Preview {
    ContentView()
        .environment(\.colorScheme, .dark)
}
