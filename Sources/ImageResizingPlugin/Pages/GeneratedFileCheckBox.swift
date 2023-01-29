//
//  SwiftUIView.swift
//  
//
//  Created by Qiwei Li on 1/29/23.
//

import SwiftUI

struct GeneratedFileCheckBox: View {
    @State var enabled: Bool
    
    let task: ResizingTask
    
    @EnvironmentObject var model: ResizingModel
    
    init(task: ResizingTask) {
        self._enabled = .init(initialValue: task.enabled)
        self.task = task
    }
    
    var body: some View {
        Toggle("", isOn: $enabled)
            .onChange(of: enabled) { newValue in
                model.enable(task: task, with: newValue)
            }
    }
}
