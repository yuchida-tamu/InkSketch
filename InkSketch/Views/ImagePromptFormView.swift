//
//  ImagePromptFormView.swift
//  InkSketch
//
//  Created by Yuta Uchida on 2025/05/17.
//

import SwiftUI

struct ImagePromptFormView: View {
    @State var selectedKeywordId: UUID? = nil
    @Binding var prompts: [PromptKeyword]
    @State var motifInput = ""
    @State var showMotifInputField = true

    var body: some View {
        VStack(spacing: 24) {
            Text("Generate Your Image")
                .font(.title)
            Spacer()

            if showMotifInputField {
                VStack {
                    Text("Enter a motif for the image")
                    TextInputField(placeholder: "e.g. Skull") { value in
                        motifInput = value
                        showMotifInputField = false
                    }
                }
            }

            if motifInput.count > 0 {
                Text(motifInput)
                    .onLongPressGesture {
                        showMotifInputField = true
                        motifInput = ""
                    }
                    .font(.title)
            }

            if prompts.count > 0 {
                PrompKeywordList(
                    selectedId: $selectedKeywordId, prompts: $prompts)
            } else {
                Text("Enter elements to include in the image")
                TextInputField { value in
                    prompts.append(PromptKeyword(value: value))
                }
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(16)
        .background()
    }
}

#Preview {
    struct PreviewContent: View {
        @State var prompts: [PromptKeyword] = []
        var body: some View {
            ImagePromptFormView(prompts: $prompts)
        }
    }
    return PreviewContent()
}
