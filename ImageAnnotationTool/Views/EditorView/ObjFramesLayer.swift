//
//  ObjFramesLayer.swift
//  ImageAnnotationTool
//
//  Created by Sergey on 10.06.2020.
//  Copyright © 2020 R2. All rights reserved.
//

import SwiftUI

struct ObjectFramesLayer: View {
    
    @EnvironmentObject var currentDoc: Document
    var zoom: CGFloat
    var size: CGSize
    @GestureState private var dragGestureState: DragGesture.Value? = nil
    
    private var newObjectFrame: ObjectFrame {
        ObjectFrame(dragGesureValue: dragGestureState!)
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: size.width * zoom, height: size.height * zoom)
                .position(CGPoint(x: size.width / 2, y: size.height / 2))
                .opacity(0)
                .contentShape(Rectangle())
                .gesture(dragGesture)
            //new object frame that currently in the adjust process
            if self.dragGestureState != nil && currentDoc.labelManager.selectedLabel != nil {
                ObjFrameView(width: self.newObjectFrame.width,
                             height: self.newObjectFrame.height,
                             position: self.newObjectFrame.position,
                             color: currentDoc.labelManager.selectedLabel!.color,
                             selected: true)
            }
            //object frames already existing in the model
            if self.currentDoc.currentImageInfo?.annotations != nil {
                ForEach(self.currentDoc.currentImageInfo!.annotations!, id: \.self) { annotation in
                    ObjFrameView(width: self.zoomedValue(annotation.coordinates.width),
                                 height: self.zoomedValue(annotation.coordinates.height),
                                 position: self.zoomedPoint(IntPoint(annotation.coordinates)),
                                 color: annotation.label.color,
                                 selected: false)
                        .contextMenu {
                            Button(action: {
                                self.currentDoc.currentImageInfo?.deleteObjAnnotation(annotation)
                                self.currentDoc.objectWillChange.send()
                                } ) { Text("Delete") }
                    }
                }
            }
        }

    }
    
    //MARK: - Gestures
    private struct ObjectFrame {
        let width: CGFloat
        let height: CGFloat
        let position: CGPoint
        
        init(dragGesureValue: DragGesture.Value) {
            width = (dragGesureValue.location.x - dragGesureValue.startLocation.x).magnitude
            height = (dragGesureValue.location.y - dragGesureValue.startLocation.y).magnitude
            position = CGPoint(x: (dragGesureValue.startLocation.x + dragGesureValue.location.x)/2,
                               y: (dragGesureValue.startLocation.y + dragGesureValue.location.y)/2)
        }
    }
    
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 1, coordinateSpace: .local)
            .updating($dragGestureState) { currDrugState, dragGestureState, _ in
                dragGestureState = currDrugState
        }
        .onEnded { currDrugState in
            if let selectedLabel = self.currentDoc.labelManager.selectedLabel {
                let newObjectFrame = ObjectFrame(dragGesureValue: currDrugState)
                let unzoomedPoint = self.unzoomedPoint(newObjectFrame.position)
                let coordinates = ObjectAnnotation.Coordinates(x: unzoomedPoint.x,
                                                    y: unzoomedPoint.y,
                                                    width: self.unzoomedValue(newObjectFrame.width),
                                                    height: self.unzoomedValue(newObjectFrame.height))
                let newAnnotation = ObjectAnnotation(label: selectedLabel, coordinates: coordinates)
                self.currentDoc.currentImageInfo?.addNewObjAnnotation(newAnnotation)
                self.currentDoc.objectWillChange.send()
            }

        }
    }
    
    //MARK: - Zoom calculations
    private func zoomedValue(_ val: Int) -> CGFloat {
        zoom == 0 ? CGFloat(val) : CGFloat(val) * zoom
    }
    
    private func unzoomedValue(_ val: CGFloat) -> Int {
        zoom == 0 ? Int(val) : Int(val / zoom)
    }
    
    private var zoomTransformation: CGAffineTransform {
        let a_d = zoom
        let t = { ($0 - self.zoom * $0) / 2 }
        return CGAffineTransform(a: a_d           , b: 0,
                                 c: 0             , d: a_d,
                                 tx: t(size.width), ty: t(size.height))
    }
    
    private func zoomedPoint(_ intPoint: IntPoint) -> CGPoint {
        let point = CGPoint(x: intPoint.x, y: intPoint.y)
        return point.applying(zoomTransformation)
    }

    private func unzoomedPoint(_ point: CGPoint) -> IntPoint {
        return IntPoint(point.applying(zoomTransformation.inverted()))
    }
}
