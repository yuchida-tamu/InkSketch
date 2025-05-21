//
//  SketchGalleryView.swift
//  InkSketch
//
//  Created by Yuta Uchida on 2025/05/18.
//

import SwiftData
import SwiftUI

struct SketchGalleryView: View {
    @Environment(\.modelContext) private var context
    @Query var sketches: [Sketch]
    @State private var gridColumns = Array(
        repeating: GridItem(.flexible()), count: 3)
    @State private var selectedImage: Sketch?

    var body: some View {
        VStack {
            if sketches.count > 0 {
                LazyVGrid(columns: gridColumns) {
                    ForEach(sketches) { item in
                        GalleryItem(item: item){ image in
                            removeImage(item: image)
                        }
                        .onTapGesture {
                            selectedImage = item
                        }
                        .onLongPressGesture{
                            removeImage(item: item)
                        }

                    }
                }
                .padding()
                Spacer()
            } else {
                Text("NO DATA")
            }
        }
        .sheet(
            item: $selectedImage,
            onDismiss: {
                selectedImage = nil
            }
        ) { item in
            VStack {
                if let data = Data(base64Encoded: item.data),
                    let uiImage = UIImage(data: data)
                {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            .padding(16)
        }
    }

    private func removeImage(item: Sketch) {
        context.delete(item)
    }
    
    struct GalleryItem: View {
        var item: Sketch
        var onRemove: (Sketch) -> Void
        @State var showDeleteButton = false
        
        var body: some View {
            ZStack(alignment: .topTrailing) {
                VStack {
                    if let data = Data(base64Encoded: item.data),
                       let uiImage = UIImage(data: data)
                    {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    
                }
                .frame(width: 96, height: 96)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .onLongPressGesture{
                    showDeleteButton.toggle()
                }
                if showDeleteButton {
                    Button{
                        onRemove(item)
                        showDeleteButton = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .padding(4)
                    .foregroundStyle(.red)
                }
            }
        }
        
        init(item: Sketch, onRemove: @escaping (Sketch) -> Void) {
            self.item = item
            self.onRemove = onRemove
        }
    }
}

#Preview {
    SketchGalleryView()
        .modelContainer(SampleData.previewContainer)
}
