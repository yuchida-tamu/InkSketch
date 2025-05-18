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

    @State private var keyword = ""
    @State private var prompts: [PromptKeyword] = []
    @State private var selectedKeywordId: UUID? = nil
    @State private var selectedDent: PresentationDetent = .fraction(0.1)

    private var viewModel: ImageGeneratorViewModel

    var isSubmitButtonDisabled: Bool {
        return viewModel.isProcessing || prompts.count < minPromptCount
    }

    // MARK: BODY
    var body: some View {
        // DISPLAY
        VStack {
            GeometryReader { geometry in
                ZStack {
                    // Image Display
                    if let image = viewModel.uiImage {
                        VStack {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    } else if !viewModel.isProcessing {
                        Text("NO IMAGE")
                    }
                    
                    if viewModel.isProcessing {
                        ProgressView()
                    }

                }
                .frame(width: geometry.size.width, height: geometry.size.width)
                .background(.gray)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .frame(width: .infinity, height: 512)

        }  // - VStack
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background()
        .sheet(isPresented: .constant(true)) {
            ImagePromptFormView(
                fetching: viewModel.isProcessing,
                size: $selectedDent
            ) { data in
                viewModel.generateImage(
                    motif: data.motif, keywords: data.keywords)
            }
            .interactiveDismissDisabled()
            .presentationDetents(
                [.fraction(0.1), .fraction(0.2), .medium],
                selection: $selectedDent
            )
            .presentationDragIndicator(.visible)
        }
        .onDisappear {
            viewModel.initTask()
        }
    }

    init() {
        let model = OpenAIModel()
        model.model = "dall-e-2"
        let client = OpenAIClient(
            keyManager: APIKeyManager.shared, model: model)
        let service = ImageGeneratorService(client: client)

        viewModel = ImageGeneratorViewModel(service: service)
    }
}

#Preview {
    ImageGeneratorView()
        .environment(\.colorScheme, .dark)
}
