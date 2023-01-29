//
//  SwiftUIView.swift
//  
//
//  Created by Qiwei Li on 1/29/23.
//

import SwiftUI

struct PlatformCheckBox: View {
    let platform: Platform
    
    @State var value: Bool
    @EnvironmentObject var model: ResizingModel
    
    init(platform: Platform, platforms: [Platform]) {
        if platforms.contains(platform) {
            _value = .init(initialValue: true)
        } else {
            _value = .init(initialValue: false)
        }
        self.platform = platform
    }
    
    
    var body: some View {
        Toggle(platform.rawValue, isOn: $value)
            .onChange(of: value) { newValue in
                model.enable(platform: platform, with: newValue)
            }
    }
}
