//
//  ImageView.swift
//  ImageAnnotationTool
//
//  Created by Sergey on 11.05.2020.
//  Copyright © 2020 R2. All rights reserved.
//

import SwiftUI

struct EditorView: View {
    
    @EnvironmentObject var currentDoc: Document
    var zoom: CGFloat
    var size: CGSize
    
    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            imageView.overlay(objectFramesLayer)
        }
    }
    
    private var imageView: some View {
        Image(nsImage: self.currentDoc.imageManager.currentNSImage)
            .scaleEffect(zoom)
            .aspectRatio(contentMode: .fit)
    }
    
    private var objectFramesLayer: some View {
        ObjectFramesLayer(zoom: zoom,
                          size: size)
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        EditorView(zoom: 0.2,
                  size: CGSize(width: 400, height: 300))
            .environmentObject(Document())
    }
}
