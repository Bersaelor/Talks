//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


struct StarData {
    let right_ascension: Float
    let declination: Float
    let hip_id: Int32?
    let hd_id: Int32?
    let hr_id: Int32?
    let gl_id: String?
    let bayer_flamstedt: String?
    let properName: String?
    let distance: Double
    let rv: Double?
    let mag: Double
    let absmag: Double
    let spectralType: String?
    let colorIndex: Float?
}

print(MemoryLayout<StarData>.stride)


struct StarDataNoStrings {
    let right_ascension: Float
    let declination: Float
    let hip_id: Int32?
    let hd_id: Int32?
    let hr_id: Int32?
    let gl_id: Int16?
    let bayer_flamstedt: Int16?
    let properName: Int16?
    let distance: Double
    let rv: Double?
    let mag: Double
    let absmag: Double
    let spectralType: Int16?
    let colorIndex: Float?
}

print(MemoryLayout<StarDataNoStrings>.stride)




struct StarDataFinal {
    let right_ascension: Float
    let declination: Float
    let spectralType: Int16
    let gl_id: Int16
    let bayer_flamstedt: Int16
    let properName: Int16
    let db_id: Int32
    let hip_id: Int32
    let hd_id: Int32
    let hr_id: Int32
    let rv: Float
    let mag: Float
    let absmag: Float
    let colorIndex: Float
    let distance: Double
}




print(MemoryLayout<StarDataFinal>.stride)











dump("✅")
