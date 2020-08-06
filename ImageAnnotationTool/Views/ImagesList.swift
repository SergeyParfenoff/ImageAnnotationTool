//
//  ImagesList.swift
//  ImageAnnotationTool
//
//  Created by Sergey on 04.08.2020.
//  Copyright © 2020 R2. All rights reserved.
//

import SwiftUI

struct ImagesList: View {
    @EnvironmentObject var currentDoc: Document
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            HStack {
                Text(" Images:")
                Spacer()
                Button("Rescan") {
                    self.currentDoc.imageManager.checkAndUpdateImagesInfo()
                }
            }
            
            List(selection: $currentDoc.imageManager.currentImage) {
                ForEach(currentDoc.imageManager.images) { image in
                    ImageRow(image: image,
                             labelsDescription: self.currentDoc.imageManager.labelsDescription(image: image))
                        .tag(image)
                }
            }
            
        }.frame(minWidth: 100, idealWidth: 150, maxWidth: 300)
    }
}

struct ImageRow: View {
    var image: ImageManager.Image
    var labelsDescription: [(String, Color)]
    
    var body: some View {
        HStack {
            Image(nsImage: image.preview)
                .frame(width: 30, height: 30)
                .fixedSize()
                .cornerRadius(4.0)
            VStack(alignment: .leading) {
                Text(image.id)
                    .font(.caption)
                HStack {
                    ForEach(labelsDescription, id: (\.0)) { (label, color) in
                        Text(label)
                            .font(.caption)
                            .italic()
                            .background(color)
                    }
                }
                
            }
        }
    }
}

struct ImagesList_Previews: PreviewProvider {
    static var previews: some View {
        let doc = Document()
        return ImagesList().environmentObject(doc)
    }
}
