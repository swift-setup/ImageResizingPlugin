//
//  File.swift
//  
//
//  Created by Qiwei Li on 1/29/23.
//

import Foundation
import AppKit


class ResizingService {
    /// Resizes an `NSImage` to a given target size.
    /// - Parameters:
    ///   - image: The `NSImage` to be resized.
    ///   - targetSize: The target size for the resized `NSImage`.
    /// - Returns: A resized `NSImage` with the target size.
    func resizeImage(image: NSImage, targetSize: CGSize) -> NSImage {
        // Calculate the original size of the image
        let originalSize = image.size
        
        // Calculate the ratio of the target size to the original size for both width and height
        let widthRatio = targetSize.width / originalSize.width
        let heightRatio = targetSize.height / originalSize.height
        
        // Determine the new size of the image based on the larger ratio
        let newSize = widthRatio > heightRatio ?
        CGSize(width: targetSize.width, height: originalSize.height * widthRatio) :
        CGSize(width: originalSize.width * heightRatio, height: targetSize.height)
        
        // Create a rect with the new size
        let rect = NSRect(origin: .zero, size: newSize)
        
        // Create a new image with the target size
        let resizedImage = NSImage(size: targetSize)
        
        // Lock focus on the new image
        resizedImage.lockFocus()
        
        // Draw the original image in the rect with the new size
        image.draw(in: rect, from: .zero, operation: .copy, fraction: 1.0)
        
        // Unlock focus on the new image
        resizedImage.unlockFocus()
        
        // Return the resized image
        return resizedImage
    }
}
