//
//  LabelList.swift
//  ImageAnnotationTool
//
//  Created by Сергей on 22.04.2020.
//  Copyright © 2020 R2. All rights reserved.
//

import SwiftUI

struct LabelList: View {
    @EnvironmentObject var currentDoc: Document
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Text(" Labels:")
            
            List(selection: $currentDoc.labelManager.selectedLabel) {
                ForEach(currentDoc.labelManager.labels) { label in
                    LabelRow(label)
                        .tag(label)
                }
            }
                
            HStack(spacing: 0) {
                Button(action: { _ = self.currentDoc.labelManager.addLabel() },
                       label:  { Text("+") } )
                Button(action: { self.currentDoc.labelManager.deleteLabel() },
                       label: { Text("-") } )
                Spacer()
            }
            
        }.frame(minWidth: 100, idealWidth: 150, maxWidth: 300)
        
    }
}

struct LabelRow: View {
    var label: Label
    @State var editableText: String
    
    var body: some View {
        HStack {
            Rectangle()
                .frame(width: 20, height: 20)
                .fixedSize()
                .opacity(0)
                .background(label.color)
                .cornerRadius(4.0)
            TextField("Label name",
                      text: $editableText,
                      onCommit: { self.label.text = self.editableText } )
        }
    }
    
    init(_ label: Label) {
        self.label = label
        self._editableText = State(initialValue: label.text)
    }
}

struct LabelList_Previews: PreviewProvider {
    static var previews: some View {
        let doc = Document()
        if doc.labelManager.labels.isEmpty {
            for counter in 0...9 {
                _ = doc.labelManager.addLabel("Test \(counter)")
            }
        }
        return LabelList().environmentObject(doc)
    }
}
