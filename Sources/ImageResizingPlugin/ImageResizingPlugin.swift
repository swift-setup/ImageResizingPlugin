import PluginInterface
import SwiftUI

struct ImageResizingPlugin: PluginInterfaceProtocol {
    var manifest: ProjectManifest = ProjectManifest(displayName: "Image Resizing plugin", bundleIdentifier: "com.sirily11.imageResize", author: "sirily11", shortDescription: "An useful plugin for create a image assets for iOS app", repository: "https://github.com/swift-setup/ImageResizingPlugin", keywords: [])
        
    var id = UUID()
    let panelUtils: NSPanelUtilsProtocol
    let fileUtils: FileUtilsProtocol
    
    public init(fileUtils: FileUtilsProtocol, panelUtils: NSPanelUtilsProtocol) {
        self.fileUtils = fileUtils
        self.panelUtils = panelUtils
    }
    
    var view: some View {
       HomeView(panelUtils: panelUtils, fileUtils: fileUtils)
            .padding()
    }
}


@_cdecl("createPlugin")
public func createPlugin() -> UnsafeMutableRawPointer {
    return Unmanaged.passRetained(ImageResizingPluginBuilder()).toOpaque()
}

public final class ImageResizingPluginBuilder: PluginBuilder {
    public override func build(fileUtils: FileUtilsProtocol, nsPanelUtils: NSPanelUtilsProtocol, storeUtils: StoreUtilsProtocol) -> any PluginInterfaceProtocol {
        ImageResizingPlugin(fileUtils: fileUtils, panelUtils: nsPanelUtils)
    }
}

