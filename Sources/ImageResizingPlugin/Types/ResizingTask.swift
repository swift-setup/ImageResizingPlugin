//
//  File.swift
//  
//
//  Created by Qiwei Li on 1/29/23.
//

import Foundation
import AppKit

enum Platform: String, CaseIterable {
    case mac = "mac"
    case iPhone = "iphone"
    case iPad = "iPad"
}

struct AppAssetsJSONItem: Codable {
    let filename: String
    let idiom: String
    let scale: String
    let size: String
}

struct Info: Codable {
    let author: String
    let version: Int
}


struct AppAssets: Codable {
    let images: [AppAssetsJSONItem]
    let info: Info
}

struct ResizingTask: Identifiable {
    let id = UUID()
    let image: NSImage
    var generatedImage: NSImage? = nil
    let targetSize: CGSize
    var finished: Bool = false
    var enabled: Bool = true
    
    var outputName: String {
        get {
            let size = String(format: "%.0f", targetSize.width)
            return "\(size).png"
        }
    }
    
    var outputSize: String {
        get {
            let width = String(format: "%.0f", targetSize.width)
            let height =  String(format: "%.0f", targetSize.height)
            return "\(width)x\(height)"
        }
    }
    
    func getAseetJSONItem(platforms: [Platform]) -> [AppAssetsJSONItem] {
        var items: [AppAssetsJSONItem] = []
        
        for platform in platforms {
            items.append(contentsOf: [
                AppAssetsJSONItem(filename: outputName, idiom: platform.rawValue, scale: "1x", size: outputSize),
                AppAssetsJSONItem(filename: outputName, idiom: platform.rawValue, scale: "2x", size: outputSize)
            ])
        }
        
        return items
    }
}
