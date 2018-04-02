//
//  MemoryCachePerformanceExampleTests.swift
//  MemoryCachePerformanceExampleTests
//
//  Created by Konrad Feiler on 02.04.18.
//  Copyright © 2018 Konrad Feiler. All rights reserved.
//

import XCTest
@testable import MemoryCachePerformanceExample

class MemoryCacheTests: XCTestCase {
    
    static let testSize = 10_000_000
    
    static var array8: ContiguousArray<Block8> = []
    static var array16: ContiguousArray<Block16> = []
    static var array32: ContiguousArray<Block32> = []
    static var array48: ContiguousArray<Block48> = []
    static var array64: ContiguousArray<Block64> = []
    static var array96: ContiguousArray<Block96> = []
    static var array128: ContiguousArray<Block128> = []
    static var array192: ContiguousArray<Block192> = []
    static var array256: ContiguousArray<Block256> = []
    static var array512: ContiguousArray<Block512> = []

    override class func setUp() {
        super.setUp()
        
        array8 = ContiguousArray((0..<testSize).map { return Block8(n: $0) })
        array16 = ContiguousArray((0..<testSize).map { return Block16(n: $0, k: $0) })
        array32 = ContiguousArray((0..<testSize).map { return Block32(k: $0, l: $0, m: $0, n: $0) })
        array48 = ContiguousArray((0..<testSize).map { return Block48(k: $0, l: $0, m: $0, n: $0, o: $0, p: $0) })
        array64 = ContiguousArray((0..<testSize).map { return Block64(k: $0, l: $0, m: $0, n: $0, o: $0, p: $0, q: $0, r: $0) })
        array96 = ContiguousArray((0..<testSize).map { return Block96(k: $0, l: $0, m: $0, n: $0, o: $0, p: $0) })
        array128 = ContiguousArray((0..<testSize).map { return Block128(k: $0, l: $0, m: $0, n: $0) })
        array192 = ContiguousArray((0..<testSize).map { return Block192(k: $0, l: $0, n: $0) })
        array256 = ContiguousArray((0..<testSize).map { return Block256(k: $0, n: $0) })
        array512 = ContiguousArray((0..<testSize).map { return Block512(n: $0) })

    }
    
    func test8() {
        self.measure {
            _ = MemoryCacheTests.array8.reduce(0) { $0 + $1.n }
        }
    }
    
    func test16() {
        self.measure {
            _ = MemoryCacheTests.array16.reduce(0) { $0 + $1.n }
        }
    }
    
    func test32() {
        self.measure {
            _ = MemoryCacheTests.array32.reduce(0) { $0 + $1.n }
        }
    }
    
    func test48() {
        self.measure {
            _ = MemoryCacheTests.array48.reduce(0) { $0 + $1.n }
        }
    }
    
    func test64() {
        self.measure {
            _ = MemoryCacheTests.array64.reduce(0) { $0 + $1.n }
        }
    }
    
    func test96() {
        self.measure {
            _ = MemoryCacheTests.array96.reduce(0) { $0 + $1.n }
        }
    }
    
    func test128() {
        self.measure {
            _ = MemoryCacheTests.array128.reduce(0) { $0 + $1.n }
        }
    }
    
    func test192() {
        self.measure {
            let _ = MemoryCacheTests.array192.reduce(0) { $0 + $1.n }
        }
    }

    func test256() {
        self.measure {
            let _ = MemoryCacheTests.array256.reduce(0) { $0 + $1.n }
        }
    }

    func test512() {
        self.measure {
            let _ = MemoryCacheTests.array512.reduce(0) { $0 + $1.n }
        }
    }
}
