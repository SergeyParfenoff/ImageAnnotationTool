//
//  Array+Identifiable.swift
//  ImageAnnotationTool
//
//  Created by Sergey on 01.06.2020.
//  Copyright © 2020 R2. All rights reserved.
//

import Foundation

extension Array where Element: Identifiable {
    mutating func updateElement(_ element: Element) {
        if let idx = self.firstIndex(where: { $0.id == element.id }) {
            self[idx] = element
        }
    }
}
