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

    private var images: [UIImage] {
        sketches.compactMap { sketch in
            if let data = Data(base64Encoded: sketch.data),
                let uiImage = UIImage(data: data)
            {
                return uiImage
            }
            return nil
        }
    }

    var body: some View {
        VStack {
            if sketches.count > 0 {
                LazyVGrid(columns: gridColumns) {
                    ForEach(images, id: \.self) { item in
                        VStack {
                            Image(uiImage: item)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        .frame(width: 96, height: 96)
                        .clipShape(RoundedRectangle(cornerRadius: 4))

                    }
                }
                .padding()
                Spacer()
            } else {
                Text("NO DATA")
            }
        }

    }
}

#Preview {
    SketchGalleryView()
        .modelContainer(SampleData.previewContainer)
}
