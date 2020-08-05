//
//  LabelManager.swift
//  ImageAnnotationTool
//
//  Created by Sergey on 05.05.2020.
//  Copyright © 2020 R2. All rights reserved.
//

import Foundation
import SwiftUI

final class LabelManager {
    weak var doc: Document?
    private(set) var labels = [Label]() {
        didSet {
            doc?.objectWillChange.send()
        }
    }
    var selectedLabel: Label? {
        didSet {
            doc?.objectWillChange.send()
        }
    }
    
    private(set) var colorManager = LabelColorManager()
    
    func addLabel(_ initText: String? = nil) -> Label {
        let text = initText ?? "New label \(labels.count + 1)"
        
        for label in labels {
            if label.text == text {
                return label
            }
        }
        
        let newLabel = Label(text: text, color: colorManager.getColor())
        labels.append(newLabel)
        selectedLabel = newLabel
        
        return newLabel
    }
    
    func addLabel(label: Label) {
        labels.append(label)
        selectedLabel = label
    }
    
    func deleteLabel(_ label: Label? = nil) {
        if let unwrappedLabel = label, let index = labels.firstIndex(of: unwrappedLabel) {
            labels.remove(at: index)
        } else if let label = selectedLabel, let index = labels.firstIndex(of: label) {
            labels.remove(at: index)
        }
    }
    
    subscript(i: Int) -> Label {
        get {
            self.labels[i]
        }
        set {
            self.labels[i] = newValue
        }
    }
    
    init(doc: Document) {
        self.doc = doc
    }
}
