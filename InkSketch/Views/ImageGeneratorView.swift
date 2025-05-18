//
//  ImageGeneratorView.swift
//  InkSketch
//
//  Created by Yuta Uchida on 2025/05/10.
//

import SwiftData
import SwiftUI

struct PromptKeyword: Identifiable {
    var id: UUID = UUID()
    var value: String
}

struct ImageGeneratorView: View {
    private var viewModel: ImageGeneratorViewModel
    @Environment(\.modelContext) private var context

    @State private var selectedDent: PresentationDetent = .fraction(0.1)
    @State private var navigationPath = NavigationPath()
    @State private var isNewImage = true

    @Query var sketches: [Sketch]

    var shouldShowSheet: Bool {
        navigationPath.count == 0
    }

    var disabledSave: Bool {
        return viewModel.encodedImageData?.count ?? 0 == 0 || !isNewImage
            || viewModel.isProcessing
    }

    //MARK: BODY
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                //MARK: HEADER CONTROL
                HStack(spacing: 8) {
                    Spacer()

                    Button {
                        navigationPath.append(0)
                    } label: {
                        VStack {
                            Image(systemName: "square.grid.2x2.fill")
                            Text("\(sketches.count)").font(.caption)
                        }
                    }

                    // Save
                    Button {
                        guard let data = viewModel.encodedImageData,
                            data.count > 0
                        else { return }
                        context.insert(Sketch(data: data))
                        isNewImage = false
                    } label: {
                        VStack {
                            Image(systemName: "arrow.down.doc.fill")
                            Text("Save").font(.caption)
                        }
                    }
                    .disabled(disabledSave)
                    .padding()

                    // TODO: Export

                    // TODO: Print
                }
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)

                Spacer()

                //MARK: DISPLAY
                GeometryReader { geometry in
                    ZStack {
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
                    .frame(
                        width: geometry.size.width, height: geometry.size.width
                    )
                    .background(.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .frame(width: .infinity, height: 512)
                Spacer()
            }  // - VStack
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background()
            .sheet(isPresented: .constant(shouldShowSheet)) {
                // MARK: BOTTOM SHEET
                ImagePromptFormView(
                    fetching: viewModel.isProcessing,
                    size: $selectedDent
                ) { data in
                    viewModel.generateImage(
                        motif: data.motif, keywords: data.keywords)

                    isNewImage = true
                }
                .interactiveDismissDisabled()
                .presentationDetents(
                    [.fraction(0.1), .fraction(0.2), .medium],
                    selection: $selectedDent
                )
                .presentationDragIndicator(.visible)
                .presentationBackgroundInteraction(.enabled)
            }
            //MARK: NAVIGATION
            .navigationDestination(
                for: Int.self,
                destination: { _ in
                    SketchGalleryView()
                        .navigationTitle("Sketch Gallery")
                }
            )
            .onDisappear {
                viewModel.initTask()
            }
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
    let modelContainer: ModelContainer = {
        let schema = Schema([Sketch.self])
        let modelConfiguration = ModelConfiguration(
            schema: schema, isStoredInMemoryOnly: true)
        do {
            return try ModelContainer(
                for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    return ImageGeneratorView()
        .environment(\.colorScheme, .dark)
        .modelContainer(modelContainer)
}
