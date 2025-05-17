//
//  ImagePromptFormView.swift
//  InkSketch
//
//  Created by Yuta Uchida on 2025/05/17.
//

import SwiftUI

struct ImagePromptFormView: View {
    @State private var prompts: [PromptKeyword] = []
    @State private var selectedKeywordId: UUID? = nil
    @State private var motifInput = ""
    @State private var showMotifInputField = true
    
    private var submit: (FormValue) -> Void
    
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
            Button {
                submit(FormValue(motif: motifInput, keywords: prompts.map({$0.value}).joined(separator: ", ")))
            } label: {
                Text("GENERATE")
                    .bold()
            }
            .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(16)
        .background()
    }
    
    init( submit: @escaping (FormValue) -> Void) {
        self.submit = submit
    }
    
    struct FormValue {
        var motif: String
        var keywords: String
    }
}

#Preview {
    ImagePromptFormView { data in
        print("motif: \(data.motif), keywords: \(data.keywords)")
    }
}
