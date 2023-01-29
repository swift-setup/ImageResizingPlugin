//
//  SwiftUIView.swift
//  
//
//  Created by Qiwei Li on 1/29/23.
//

import SwiftUI
import PluginInterface

struct HomeView: View {
    @StateObject var model = ResizingModel()
    
    let panelUtils: NSPanelUtilsProtocol
    let fileUtils: FileUtilsProtocol
    
    var body: some View {
        VStack {
            HStack {
                Text("Source Image")
                Spacer()
                Button("Pick Source Image") {
                    pickSourceImage()
                }
            }
            
            HStack {
                Text("Platforms")
                Spacer()
                ForEach(Platform.allCases, id: \.rawValue) { platform in
                    PlatformCheckBox(platform: platform, platforms: model.platforms)
                }
            }
            
            TabView {
                ImageView(image: model.sourceImage).tabItem {
                    Text("Image preview")
                }
                
                FileListView(tasks: model.targetResizingTasks)
                    .tabItem {
                        Text("Generated images")
                    }
            }
            
            HStack {
                Spacer()
                Button("Generate") {
                    generate()
                }
                .disabled(model.sourceImage == nil)
            }
        }
        .onAppear {
            model.setUp(fileUtils: fileUtils, panelUtils: panelUtils)
        }
        .environmentObject(model)
    }
    
    func generate() {
        do {
            let url = try fileUtils.showSaveFilePanel(allowedFileTypes: [], defaultFileName: "AppIcon.appiconset")
            model.start(save: url)
        } catch {
            panelUtils.alert(title: "Cannot generate", subtitle: error.localizedDescription, okButtonText: "OK", alertStyle: .critical)
        }
    }
    
    func pickSourceImage() {
        do {
            let file = try fileUtils.showOpenFilePanel(allowedFileTypes: [.png])
            let image = NSImage(byReferencing: file)
            try model.addSource(image: image)
        } catch {
            panelUtils.alert(title: "Cannot pick image", subtitle: error.localizedDescription, okButtonText: "OK", alertStyle: .critical)
        }
    }
}
