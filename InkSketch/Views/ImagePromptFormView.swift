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
    @Binding private var size: PresentationDetent

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
            if size == .medium {
                if motifInput.count > 0 {
                    HStack {
                        Text(motifInput)
                            .font(.headline)
                        Button {
                            showMotifInputField = true
                        } label: {
                            Image(systemName: "pencil")
                        }
                    }
                }
                if showMotifInputField {
                    VStack(alignment: .leading) {
                        Text("Enter a motif you'd like to generate").font(.caption)
                        TextInputField(placeholder: "e.g. Skull") { value in
                            motifInput = value
                            showMotifInputField = false
                        }
                    }
                }

                PrompKeywordList(
                    selectedId: $selectedKeywordId, prompts: $prompts)

                VStack(alignment: .leading) {
                    Text("Add elements to include in the image").font(.caption)
                    TextInputField { value in
                        prompts.append(PromptKeyword(value: value))
                    }
                }

                Spacer()
            }  // Full Content
            else if size == .fraction(0.2) {
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

            if size == .fraction(0.1)
                || (motifInput.count == 0 && size == .fraction(0.2))
            {
                Button {
                    size = .medium
                } label: {
                    Text("OPEN")
                        .bold()
                }
                .buttonStyle(.bordered)
            } else {
                Button {
                    submit(
                        FormValue(
                            motif: motifInput,
                            keywords: prompts.map({ $0.value }).joined(
                                separator: ", ")))
                    size = .fraction(0.2)
                } label: {
                    Text("GENERATE")
                        .bold()
                }
                .buttonStyle(.bordered)
                .disabled(disableSubmit)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
        .background()
    }

    init(
        fetching: Bool = false, size: Binding<PresentationDetent>,
        submit: @escaping (FormValue) -> Void
    ) {
        self._size = size
        self.submit = submit
        self.fetching = fetching
    }

    struct FormValue {
        var motif: String
        var keywords: String
    }
}

#Preview {
    struct PreviewContent: View {
        @State var size: PresentationDetent = .medium
        var body: some View {
            ImagePromptFormView(size: $size) { data in
                print("motif: \(data.motif), keywords: \(data.keywords)")
            }
        }
    }
    return PreviewContent()
}
