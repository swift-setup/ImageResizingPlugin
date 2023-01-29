//
//  SwiftUIView.swift
//  
//
//  Created by Qiwei Li on 1/29/23.
//

import SwiftUI

struct ImageView: View {
    let image: NSImage?
    
    var body: some View {
        if let image = image {
            Image(nsImage: image)
        } else {
            Text("No image selected")
        }
    }
}
