//
//  ViewController.swift
//  MemoryCachePerformanceExample
//
//  Created by Konrad Feiler on 02.04.18.
//  Copyright © 2018 Konrad Feiler. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

struct Block4 {
    let n: Int32
}

struct Block8 {
    let n: Int
}

struct Block16 {
    let n: Int
    let k: Int
}

struct Block32 {
    let k: Int
    let l: Int
    let m: Int
    let n: Int
}

struct Block48 {
    let k: Int
    let l: Int
    let m: Int
    let n: Int
    let o: Int
    let p: Int
}

struct Block64 {
    let k: Int
    let l: Int
    let m: Int
    let n: Int
    let o: Int
    let p: Int
    let q: Int
    let r: Int
}

struct Block96 {
    let k: Int
    let l: Int
    let m: Int
    let n: Int
    let o: Int
    let p: Int
    let q: String = "Test"
    let r: String = "Test"
}

struct Block128 {
    let k: Int
    let l: Int
    let m: Int
    let n: Int
    let o: String = "Test"
    let p: String = "Test"
    let q: String = "Test"
    let r: String = "Test"
}

struct Block192 {
    let k: Int
    let l: Int
    let m: String = "Test"
    let n: Int
    let o: String = "Test"
    let p: String = "Test"
    let q: String = "Test"
    let r: String = "Test"
    let s: String = "Test"
    let t: String = "Test"
}

struct Block256 {
    let k: Int
    let m: String = "Test"
    let n: Int
    let o: String = "Test"
    let p: String = "Test"
    let q: String = "Test"
    let r: String = "Test"
    let s: String = "Test"
    let t: String = "Test"
    let u: String = "Test"
    let v: String = "Test"
    let w: String = "Test"
}

struct Block512 {
    let m: String = "Test"
    let n: Int
    let o: String = "Test"
    let p: String = "Test"
    let q: String = "Test"
    let r: String = "Test"
    let s: String = "Test"
    let t: String = "Test"
    let u: String = "Test"
    let v: String = "Test"
    let w: String = "Test"
    let w1: String = "Test"
    let w2: String = "Test"
    let w3: String = "Test"
    let w4: String = "Test"
    let w5: String = "Test"
    let w6: String = "Test"
    let w7: String = "Test"
    let w8: String = "Test"
    let w9: String = "Test"
    let w10: String = "Test"
    let w11: String = "Test"
}

