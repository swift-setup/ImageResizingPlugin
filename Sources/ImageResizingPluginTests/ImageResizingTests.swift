//
//  ImageResizingTests.swift
//  
//
//  Created by Qiwei Li on 1/29/23.
//

import XCTest
@testable import ImageResizingPlugin


final class ImageResizingTests: XCTestCase {

    func testEnablePlatform() async throws {
        let model = ResizingModel()
        await model.enable(platform: .iPad, with: false)
        XCTAssertEqual(model.platforms, [.iPhone, .mac])
        
        await model.enable(platform: .iPhone, with: false)
        XCTAssertEqual(model.platforms, [.mac])
        
        await model.enable(platform: .iPhone, with: true)
        XCTAssertEqual(model.platforms, [.mac, .iPhone])
        
        await model.enable(platform: .iPhone, with: false)
        await model.enable(platform: .mac, with: false)
        await model.enable(platform: .iPhone, with: false)
        XCTAssertEqual(model.platforms, [])
        
        await model.enable(platform: .iPhone, with: true)
        await model.enable(platform: .mac, with: true)
        await model.enable(platform: .iPad, with: true)
        await model.enable(platform: .iPhone, with: true)
        await model.enable(platform: .mac, with: true)
        await model.enable(platform: .iPad, with: true)
        XCTAssertEqual(model.platforms, [.iPhone, .mac, .iPad])
    }
    
    
    func testGenerateContentsJSON() async throws {
        let model = ResizingModel()
        let task = ResizingTask(image: NSImage(), targetSize: .init(width: 512, height: 512))
        var assets = task.getAseetJSONItem(platforms: model.platforms)
        XCTAssertEqual(assets.count, 6)
        
        await model.enable(platform: .iPad, with: false)
        assets = task.getAseetJSONItem(platforms: model.platforms)
        XCTAssertEqual(assets.count, 4)
    }
}
