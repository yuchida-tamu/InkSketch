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
    var modelContainer: ModelContainer = {
        let schema = Schema([Sketch.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        do {
            return try ModelContainer(
                for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    return ContentView()
        .environment(\.colorScheme, .dark)
        .modelContainer(modelContainer)
}
