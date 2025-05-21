//
//  SketchGalleryView.swift
//  InkSketch
//
//  Created by Yuta Uchida on 2025/05/18.
//

import SwiftData
import SwiftUI

struct SketchGalleryView: View {
    @Query var sketches: [Sketch]
    @State private var gridColumns = Array(
        repeating: GridItem(.flexible()), count: 3)
    @State private var isPresentedImageSheet = false
    @State private var selectedImage: GalleryItem?

    private var images: [GalleryItem] {
        sketches.compactMap { sketch in
            if let data = Data(base64Encoded: sketch.data),
                let uiImage = UIImage(data: data)
            {
                return GalleryItem(data: uiImage)
            }
            return nil
        }
    }

    var body: some View {
        VStack {
            if sketches.count > 0 {
                LazyVGrid(columns: gridColumns) {
                    ForEach(images) { item in
                        VStack {
                            Image(uiImage: item.data)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        .frame(width: 96, height: 96)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                        .onTapGesture {
                            selectedImage = item
                            isPresentedImageSheet = true
                        }

                    }
                }
                .padding()
                Spacer()
            } else {
                Text("NO DATA")
            }
        }
        .sheet(item: $selectedImage, onDismiss: {
            selectedImage = nil
        }){ item in
            VStack {
                Image(uiImage: item.data)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .padding(16)
        }
    }
    
    struct GalleryItem: Identifiable {
        var id = UUID()
        var data: UIImage
    }
}

#Preview {
    SketchGalleryView()
        .modelContainer(SampleData.previewContainer)
}
