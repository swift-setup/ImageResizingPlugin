//
//  ResizingModel.swift
//  
//
//  Created by Qiwei Li on 1/29/23.
//

import Foundation
import AppKit
import PluginInterface

class ResizingModel: ObservableObject {
    @Published private(set) var sourceImage: NSImage? = nil
    @Published private(set) var targetResizingTasks: [ResizingTask] = []
    @Published private(set) var isLoading = false
    @Published private(set) var platforms: [Platform] = [.iPhone, .mac, .iPad]
    
    private let resizingService: ResizingService
    private var fileUtils: FileUtilsProtocol!
    private var panelUtils: NSPanelUtilsProtocol!
    
    init(resizingService: ResizingService = ResizingService()) {
        self.resizingService = resizingService
    }
    
    func setUp(fileUtils: FileUtilsProtocol, panelUtils: NSPanelUtilsProtocol) {
        self.fileUtils = fileUtils
        self.panelUtils = panelUtils
    }
    
    
    /**
     Adds a source image to the list of resizing tasks.
     - Parameter image: The source `NSImage` to be resized.
     
     - Throws: An `ImageProcessingError` if the image size is below the 1024x1024 limit.
    */
    @MainActor
    func addSource(image: NSImage) throws {
        let size = image.size
        let pixelWidth = image.representations[0].pixelsWide
        let pixelHeight = image.representations[0].pixelsHigh
        
        // check if the size belows the 1024x1024 limit
        if pixelWidth < 1024 || pixelHeight < 1024 {
            throw ImageProcessingError.invalidImageSize(size)
        }
        
        self.targetResizingTasks = AssetImageSize.allCases.map { size in
            return ResizingTask(image: image, targetSize: size.size)
        }
        self.sourceImage = image
    }
    
    @MainActor
    func enable(task: ResizingTask, with value: Bool) {
        if let index = targetResizingTasks.firstIndex(where: { t in
            t.id == task.id
        }) {
            targetResizingTasks[index].enabled = value
        }
    }
    
    
    @MainActor
    func enable(platform: Platform, with value: Bool){
        // if platform exists
        if let item = platforms.firstIndex(of: platform) {
            // and value is false, remove it
            if !value {
                platforms.remove(at: item)
            }
        } else {
            if value {
                platforms.append(platform)
            }
        }
    }
    
    @MainActor
    /**
     Start processing
     */
    func start(save to: URL) {
        do {
            isLoading = true
            var items: [AppAssetsJSONItem] = []
            for task in targetResizingTasks.filter({$0.enabled}) {
                let generated = resizingService.resizeImage(image: task.image, targetSize: task.targetSize)
                let index = targetResizingTasks.firstIndex { t in
                    t.id == task.id
                }
                targetResizingTasks[index!].generatedImage = generated
                guard let pngData = generated.pngData else {
                    throw ImageProcessingError.invalidPngData
                }
                try fileUtils.writeFile(at: to.appending(path: task.outputName), with: pngData)
                targetResizingTasks[index!].finished = true
                items.append(contentsOf: task.getAseetJSONItem(platforms: [.iPhone]))
            }
            isLoading = false
            let contentsJSON = generateContentsJSON(items: items)
            let contentsJSONData = try JSONEncoder().encode(contentsJSON)
            try fileUtils.writeFile(at: to.appending(path: "Contents.json"), with: contentsJSONData)
        } catch {
            panelUtils.alert(title: "Cannot generate png file", subtitle: error.localizedDescription, okButtonText: "OK", alertStyle: .critical)
        }
    }
    
    internal func generateContentsJSON(items: [AppAssetsJSONItem]) -> AppAssets {
        return AppAssets(images: items, info: .init(author: "xcode", version: 1))
    }
}
