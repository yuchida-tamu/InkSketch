//
//  ImagePromptFormView.swift
//  InkSketch
//
//  Created by Yuta Uchida on 2025/05/17.
//

import SwiftUI

enum FormSize {
    case minimum
    case full
}

struct ImagePromptFormView: View {
    private var size: FormSize
    
    @State private var prompts: [PromptKeyword] = []
    @State private var selectedKeywordId: UUID? = nil
    @State private var motifInput = ""
    @State private var showMotifInputField = true
    
    private var submit: (FormValue) -> Void
    private var fetching: Bool = false
    
    private var disableSubmit: Bool {
        return motifInput == "" || fetching
    }
    
    var body: some View {
        VStack(spacing: 8) {
            if size == .full {
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
            } // Full Content
            else {
                if motifInput.count > 0 {
                    Text(motifInput)
                        .padding(.vertical, 8)
                        .bold()
                } else {
                    Text("No Motif")
                        .padding(.vertical, 8)
                        .bold()
                }

                if prompts.count > 0 {
                    PrompKeywordList(
                        selectedId: $selectedKeywordId, prompts: $prompts)
                }
            }

          
            Button {
                submit(FormValue(motif: motifInput, keywords: prompts.map({$0.value}).joined(separator: ", ")))
            } label: {
                Text("GENERATE")
                    .bold()
            }
            .buttonStyle(.bordered)
            .disabled(disableSubmit)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
        .background()
    }
    
    init(fetching: Bool = false, size: FormSize = .full, submit: @escaping (FormValue) -> Void) {
        self.size = size
        self.submit = submit
        self.fetching = fetching
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
