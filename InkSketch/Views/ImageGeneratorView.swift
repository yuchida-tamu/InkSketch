//
//  ImageGeneratorView.swift
//  InkSketch
//
//  Created by Yuta Uchida on 2025/05/10.
//

import SwiftUI

struct PromptKeyword: Identifiable {
    var id: UUID = UUID()
    var value: String
}

struct ImageGeneratorView: View {
    private var maxPromptCount = 5
    private var minPromptCount = 1
    private var generator: ImageGeneratorService
    @State private var keyword = ""
    @State private var prompts: [PromptKeyword] = []
    @State private var selectedKeywordId: UUID? = nil
    @State private var currentTask: Task<(), Never>?
    @State private var imageUrl: String?
    @State private var isFetching = false

    var isSubmitButtonDisabled: Bool {
        return isFetching || prompts.count >= minPromptCount
    }
    
    // MARK: BODY
    var body: some View {
        // DISPLAY
        ZStack {
            VStack {
                Text("Generate Your Image")
                    .font(.title)
                Spacer()
                if imageUrl != nil {
                    AsyncImage(url: URL(string: imageUrl!)) { data in
                        data.image?.resizable()
                    }
                    .frame(width: .infinity, height: 256)
                }

                Spacer()
                // Keyword List
                PrompKeywordList(
                    selectedId: $selectedKeywordId, prompts: $prompts)
                // CONTROL
                PromptKeywordInputField(prompts: $prompts)
                Button {
                    currentTask?.cancel()
                    isFetching = true
                    currentTask = Task {
                        defer { isFetching = false }
                        guard prompts.count > 0 else { return }
                        guard
                            let url = await generator.generate(
                                prompts: prompts)
                        else { return }
                        imageUrl = url
                    }
                } label: {
                    Text("Confirm Prompts")
                }
                .disabled(isSubmitButtonDisabled)
                .buttonStyle(.bordered)
            }  // - VStack
            .padding()
            .onDisappear {
                currentTask?.cancel()
            }

            if isFetching {
                ProgressView()
            }
        }  // - ZStack
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background()
    }

    init() {
        let model = OpenAIModel()
        model.model = "dall-e-2"
        let client = OpenAIClient(keyManager: APIKeyManager.shared, model: model)
        generator = ImageGeneratorService(client: client)
    }
}

#Preview {
    ImageGeneratorView()
        .environment(\.colorScheme, .dark)
}
