//
//  Label.swift
//  ImageAnnotationTool
//
//  Created by Sergey on 08.06.2020.
//  Copyright © 2020 R2. All rights reserved.
//

import SwiftUI

final class Label: Comparable, Identifiable, Hashable {
    var text: String 
    let id = UUID()
    let color: Color
    
    static func < (lhs: Label, rhs: Label) -> Bool {
        lhs.text < rhs.text
    }
    
    static func == (lhs: Label, rhs: Label) -> Bool {
        lhs.text == rhs.text
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
    }
    
    init(text: String, color: Color) {
        self.text = text
        self.color = color
    }
    
    init(text: String, color: () -> Color) {
        self.text = text
        self.color = color()
    }
}
