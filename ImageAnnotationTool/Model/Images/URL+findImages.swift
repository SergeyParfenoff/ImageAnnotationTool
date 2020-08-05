//
//  FilesManager.swift
//  ImageAnnotationTool
//
//  Created by Сергей on 24.02.2020.
//  Copyright © 2020 R2. All rights reserved.
//

import Foundation

extension URL {
    func findImages() -> [URL] {
         do {
            let contents = try FileManager.default.contentsOfDirectory(atPath: self.path)
            
            let images = contents.filter {
                $0.localizedLowercase.hasSuffix(".jpg")
                || $0.localizedLowercase.hasSuffix(".jpeg")
                || $0.localizedLowercase.hasSuffix(".png")
            }
            var urls = images.map { self.appendingPathComponent($0) }
            
            let subFolders = contents
                .filter { self.appendingPathComponent($0).isDirectory }
                .map { self.appendingPathComponent($0) }
            
            for subFolder in subFolders {
                urls += subFolder.findImages()
            }
            return urls
            
        } catch {
            return []
        }
    }
    
    var isDirectory: Bool {
        return (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
}
