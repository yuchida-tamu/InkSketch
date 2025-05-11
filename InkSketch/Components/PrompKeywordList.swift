//
//  PrompKeywordList.swift
//  InkSketch
//
//  Created by Yuta Uchida on 2025/05/10.
//

import SwiftUI

struct PrompKeywordList: View {
    @Binding var selectedId: UUID?
    @Binding var prompts: [PromptKeyword]

    var body: some View {
        if prompts.count == 0 {
            Text("Enter keywords!")
                .font(.callout)
        } else {
            HStack(alignment: .center, spacing: 4) {
                ForEach(prompts) { k in
                    HStack {
                        Text(k.value)
                        if selectedId == k.id {
                            Image(systemName: "xmark")
                        }
                    }
                    .padding(
                        EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
                    )
                    .overlay {
                        Capsule()
                            .stroke(.white)
                    }
                    .onTapGesture {
                        handleTapPromptKeyword(prompt: k)
                    }
                }
                Spacer()
            }
            .frame(height: 32)
        }
    }
    private func handleTapPromptKeyword(prompt: PromptKeyword) {
        if selectedId == prompt.id {
            selectedId = nil
            prompts = prompts.filter({ item in
                item.id != prompt.id
            })
            return
        }
        selectedId = prompt.id
    }
}

#Preview {
    struct Content: View {
        @State var selectedId: UUID? = nil
        @State var prompts = [
            PromptKeyword(value: "prompt1"), PromptKeyword(value: "prompt1"),
            PromptKeyword(value: "prompt3"),
        ]

        var body: some View {
            PrompKeywordList(selectedId: $selectedId, prompts: $prompts)
        }
    }
    return Content()
}
