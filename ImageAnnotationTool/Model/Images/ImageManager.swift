//
//  ImageManager.swift
//  ImageAnnotationTool
//
//  Created by Sergey on 02.07.2020.
//  Copyright © 2020 R2. All rights reserved.
//

import Foundation
import SwiftUI

class ImageManager {
    weak var doc: Document?
    private(set) var currentNSImage = NSImage()
    private(set) var images = [Image]()
    private var indexOfCurrentImage = 0 {
        didSet {
            updateCurrentImage()
        }
    }
    
    //MARK: - Image data
    struct Image: Identifiable, Hashable {
        let id: String
        let url: URL
        let description: String
        let preview: NSImage
        
        static func imageDescription(_ url: URL, docURL: URL) -> String {
            let imagePath = url.absoluteString
            let docPath = docURL.deletingLastPathComponent().absoluteString
            let startIndex = docPath.index(docPath.endIndex, offsetBy: -1)
            return String(imagePath.suffix(from: startIndex))
        }
        
        static func imagePreview(_ url: URL) -> NSImage {
            guard let imageData = NSData(contentsOf: url) else { return NSImage() }
            let options = [
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceThumbnailMaxPixelSize: 40] as CFDictionary
            let source = CGImageSourceCreateWithData(imageData, nil)!
            let imageReference = CGImageSourceCreateThumbnailAtIndex(source, 0, options)!
            let size = NSSize(width: imageReference.width, height: imageReference.height)
            return NSImage(cgImage: imageReference, size: size)
        }
        
        init(url: URL, docURL: URL) {
            self.id = url.lastPathComponent
            self.url = url
            self.description = ImageManager.Image.imageDescription(url, docURL: docURL)
            self.preview = ImageManager.Image.imagePreview(url)
        }
    }
    
    private func updateCurrentImage() {
        DispatchQueue.main.async {
            self.currentNSImage = NSImage(byReferencing: self.images[self.indexOfCurrentImage].url)
            self.doc?.objectWillChange.send()
        }
    }
    
    func checkAndUpdateImagesInfo() {
        guard let doc = doc, let docURL = doc.fileURL else { return }
        let URLs = docURL.deletingLastPathComponent().findImages()
        let fileImageNames = Set(URLs.map { $0.lastPathComponent })
        let docImageNames = Set(doc.imagesInfo.map { $0.key })
        let newNames = fileImageNames.subtracting(docImageNames)
        let lostNames = docImageNames.subtracting(fileImageNames)
        doc.addImagesInfo(names: newNames)
        doc.delImagesInfo(names: lostNames)
        URLs.forEach { images.append(Image(url: $0, docURL: docURL)) }
        updateCurrentImage()
    }
    
    init(doc: Document) {
        self.doc = doc
    }
}

extension ImageManager {
    //MARK: - Images control
    func nextImage() {
        indexOfCurrentImage = min(indexOfCurrentImage + 1, images.endIndex - 1)
    }
    
    func prevImage() {
        indexOfCurrentImage = max(indexOfCurrentImage - 1, 0)
    }
    
    func setCurrentImage(id: String) {
        if let idx = images.firstIndex(where: { $0.id == id }) {
            indexOfCurrentImage = idx
        }
    }
    
    //MARK: - Additional info
    var currentImage: Image? {
        get {
            images.indices.contains(indexOfCurrentImage) ? images[indexOfCurrentImage] : nil
        }
        set {
            if let id = newValue?.id {
                setCurrentImage(id: id)
            }
        }
    }
    
    func labelsDescription(image: Image) -> [(String, Color)] {
        var result = [String: Color]()
        _ = doc?.imagesInfo[image.id]?.annotations?.map { result[$0.label.text] = $0.label.color }
        if result.isEmpty {
            result["No labels"] = Color.red
        }
        return result.map { ($0.key, $0.value) }.sorted { (lhv, rhv) in lhv.0 < rhv.0 }
    }
}
