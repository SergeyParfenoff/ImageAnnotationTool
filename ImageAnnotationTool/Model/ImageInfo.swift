//
//  DataFormat.swift
//  ImageAnnotationTool
//
//  Created by Сергей on 24.02.2020.
//  Copyright © 2020 R2. All rights reserved.
//

import Foundation

//MARK: - Structure of JSON doc
class ImageInfo: Codable, Equatable {
    var imagefilename: String
    var annotations: [ObjectAnnotation]?
    
    //MARK: - Annotation control
    func addNewObjAnnotation(_ objAnnotation: ObjectAnnotation) {
        if annotations == nil {
            annotations = []
        }
        annotations?.append(objAnnotation)
    }
    
    func deleteObjAnnotation(_ objAnnotation: ObjectAnnotation) {
        if let idx = annotations?.firstIndex(of: objAnnotation) {
            annotations?.remove(at: idx)
        }
    }
    
    static func == (lhs: ImageInfo, rhs: ImageInfo) -> Bool {
        lhs.imagefilename == rhs.imagefilename
    }
    
    init(imagefilename: String, annotations: [ObjectAnnotation]? = nil) {
        self.imagefilename = imagefilename
        self.annotations = annotations
    }
}

struct ObjectAnnotation: Codable, Identifiable, Hashable {
    var id = UUID()
    var label: Label
    var coordinates: Coordinates
    
    struct Coordinates: Codable, Hashable {
        var x: Int
        var y: Int
        var width: Int
        var height: Int
    }
    
    static func == (lhs: ObjectAnnotation, rhs: ObjectAnnotation) -> Bool {
        lhs.id == rhs.id
    }

    //MARK: - Codable magic
    enum CodingKeys: String, CodingKey {
        case label
        case coordinates
    }
    
    init(from decoder: Decoder) throws {
        let doc = decoder.userInfo[Document.docUserKey]! as! Document
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let labelText = try values.decode(String.self, forKey: .label)
        label = doc.labelManager.addLabel(labelText)
        coordinates = try values.decode(Coordinates.self, forKey: .coordinates)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(label.text, forKey: .label)
        try container.encode(coordinates, forKey: .coordinates)
    }
    
    //MARK: - standart init
    init(label: Label, coordinates: Coordinates) {
        self.label = label
        self.coordinates = coordinates
    }
}

//MARK: - Supporting structs
struct IntPoint {
    var x: Int
    var y: Int
    
    init(_ point: CGPoint) {
        x = Int(point.x)
        y = Int(point.y)
    }
    
    init(_ coordinates: ObjectAnnotation.Coordinates) {
        x = coordinates.x
        y = coordinates.y
    }
}
