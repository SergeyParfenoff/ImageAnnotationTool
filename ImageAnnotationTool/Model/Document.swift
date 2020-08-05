//
//  Document.swift
//  ImageAnnotationTool
//
//  Created by Сергей on 20.02.2020.
//  Copyright © 2020 R2. All rights reserved.
//

import Cocoa
import SwiftUI

class Document: NSDocument, ObservableObject {
    
    lazy var imageManager = ImageManager(doc: self)
    lazy var labelManager = LabelManager(doc: self)
    
    private(set) var imagesInfo: [String: ImageInfo] = [:]
    var currentImageInfo: ImageInfo? {
        if let id = imageManager.currentImage?.id {
            return imagesInfo[id]
        } else {
            return nil
        }
    }
    
    func addImagesInfo(names: Set<String>) {
        _ = names.map { imagesInfo[$0] = ImageInfo(imagefilename: $0) }
    }
    
    func delImagesInfo(names: Set<String>) {
        _ = names.map { imagesInfo.removeValue(forKey: $0) }
    }
    
    static var docUserKey = CodingUserInfoKey(rawValue: "doc")!
    
    //MARK: - Initializers
    override init() {
        super.init()
    }
    
    override class var autosavesInPlace: Bool {
        return true
    }
    
    override func makeWindowControllers() {
        // Create the SwiftUI view that provides the window contents.
        let contentView = MainView().environmentObject(self)

        // Create the window and set the content view.
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.contentView = NSHostingView(rootView: contentView)
        let windowController = NSWindowController(window: window)
        self.addWindowController(windowController)
    }
    
    //MARK: - JSON
    override func data(ofType typeName: String) throws -> Data {
        do {
            let encoder = JSONEncoder()
            //encoder.outputFormatting = .prettyPrinted
            let arrayImagesInfo = imagesInfo.map { $0.value }
            return try encoder.encode(arrayImagesInfo)
        } catch {
            throw error
        }
    }
    
    override func read(from data: Data, ofType typeName: String) throws {
        do {
            let decoder = JSONDecoder()
            decoder.userInfo[Document.docUserKey] = self
            let arrayImagesInfo = try decoder.decode([ImageInfo].self, from: data)
            _ = arrayImagesInfo.map { imagesInfo[$0.imagefilename] = $0 }
        } catch {
            throw error
        }
        imageManager.checkAndUpdateImagesInfo()
    }
    
}

