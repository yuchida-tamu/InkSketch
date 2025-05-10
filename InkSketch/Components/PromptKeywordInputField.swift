//
//  PromptKeywordInputField.swift
//  InkSketch
//
//  Created by Yuta Uchida on 2025/05/10.
//

import SwiftUI

struct PromptKeywordInputField: View {
    @State var keyword = ""
    @Binding var prompts: [PromptKeyword]
    var body: some View {
        HStack {
            TextField("Enter your inspiration keyword", text: $keyword)
                .onSubmit(addKeywordToStack)
                .textInputAutocapitalization(.never)

            Button(
                action: addKeywordToStack,
                label: {
                    Image(systemName: "arrow.up.circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                })
        }
        .textFieldStyle(.roundedBorder)
    }
    
    private func addKeywordToStack() {
        guard keyword != "" else { return }
        prompts.append(PromptKeyword(value: keyword))
        keyword = ""
    }
    
}

#Preview {
    struct Content: View {
        @State var prompts: [PromptKeyword] = []
        
        var body: some View {
            PromptKeywordInputField(prompts: $prompts)
        }
    }
    
    return Content()
}

