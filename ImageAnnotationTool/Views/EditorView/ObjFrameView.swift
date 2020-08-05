//
//  LabelView.swift
//  ImageAnnotationTool
//
//  Created by Sergey on 13.05.2020.
//  Copyright © 2020 R2. All rights reserved.
//

import SwiftUI

struct ObjFrameView: View {
    var width: CGFloat
    var height: CGFloat
    var position: CGPoint
    var color: Color
    @State var selected: Bool
    
    var body: some View {
        Group {
            if selected {
                selectedLabel
            } else {
                notSelectedLabel
            }
        }
        .frame(width: width, height: height)
        .position(position)
        //.onTapGesture { self.$selected.wrappedValue.toggle() }
    }
    
    var selectedLabel: some View {
        Rectangle()
            .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [5]))
            .foregroundColor(color)
            .contentShape(Rectangle())
    }
    
    var notSelectedLabel: some View {
        Rectangle()
            .stroke(color, lineWidth: 2)
            .opacity(0.6)
            .contentShape(Rectangle())
    }
}

struct LabelView_Previews: PreviewProvider {
    static var previews: some View {
        ObjFrameView(width: 100,
                  height: 50,
                  position: CGPoint(x: 100, y: 100),
                  color: .orange,
                  selected: false)
    }
}

