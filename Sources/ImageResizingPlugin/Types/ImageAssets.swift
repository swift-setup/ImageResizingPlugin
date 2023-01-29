//
//  File.swift
//  
//
//  Created by Qiwei Li on 1/29/23.
//

import Foundation

enum AssetImageSize: CGFloat, CaseIterable {
    case size16 = 16
    case size32 = 32
    case size64 = 64
    case size128 = 128
    case size256 = 256
    case size512 = 512
    case size1024 = 1024
    
    var size: CGSize {
        return CGSize(width: rawValue, height: rawValue)
    }
}
