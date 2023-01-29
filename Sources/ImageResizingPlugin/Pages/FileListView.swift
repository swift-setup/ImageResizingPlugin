//
//  SwiftUIView.swift
//  
//
//  Created by Qiwei Li on 1/29/23.
//

import SwiftUI

struct FileListView: View {
    let tasks: [ResizingTask]
    
    var body: some View {
        Table(tasks) {
            TableColumn("Selected") { task in
                GeneratedFileCheckBox(task: task)
            }
            TableColumn("Size") { task in
                Text(task.outputSize)
            }
            
            TableColumn("Generated") { task in
                BooleanView(value: task.finished)
            }
        }
    }
}

struct BooleanView: View {
    let value: Bool
    
    var body: some View {
        if value {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(Color.green)
        } else {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(Color.red)
        }
    }
}
