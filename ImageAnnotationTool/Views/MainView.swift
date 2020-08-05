//
//  MainView.swift
//  ImageAnnotationTool
//
//  Created by Сергей on 20.02.2020.
//  Copyright © 2020 R2. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var currentDoc: Document
    @State private var zoom: CGFloat = 0.2
    
    func zoomIn() { zoom = min(zoom + 0.2, 1.0) }
    func zoomOut() { zoom = max(zoom - 0.2, 0.2) }
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                ImagesList()
                LabelList()
            }
            
            GeometryReader { geometry in
                ZStack{
                    
                    HStack(spacing: 0) {
                        NavigationButton(action: { self.currentDoc.imageManager.prevImage() },
                                         label: "<",
                                         height: geometry.size.height)
                        EditorView(zoom: self.zoom,
                                   size: self.currentDoc.imageManager.currentNSImage.size)
                        NavigationButton(action: { self.currentDoc.imageManager.nextImage() },
                                         label: ">",
                                         height: geometry.size.height)
                    }

                    VStack {
                        Text(self.currentDoc.imageManager.currentImage?.description ?? "")
                            .font(.headline)
                            .frame(width: geometry.size.width - 60, alignment: .leading)
                        Spacer()
                    }

                    VStack {
                        Spacer()
                        HStack {
                            ZoomButton(action: { self.zoomOut() }, label: "-")
                            ZoomButton(action: { self.zoomIn() }, label: "+")
                        }
                    }

                }
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let doc = Document()
        return MainView().environmentObject(doc)
    }
}
