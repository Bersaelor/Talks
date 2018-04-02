build-lists: true

# How to fit a million ✨ into a 📱

![](IMG_1044.jpg)

---
## Content

* general points on optimization
* example problem
* some details on MemoryLayout of Structs in C/Swift
* Swift struct example optimization
* pretty results (hopefully)

---

## Why Optimize Code?

* shorter loading times

![inline autoplay mute loop](loading.mov)

^• happier users

---

## Why Optimize Code?

![inline fill](/Users/konrad/Downloads/maxresdefault.jpg)

* improve quality
  * graphics
	* sound
	* AI ...  

^• same but better -> happier users

---

## Why Optimize Code?

![inline autoplay loop](low battery.gif)

* battery power
* every CPU cycle on mobile costs power (and $$$ when on server)
* sometimes 0fps -> good thing

---

## Why Optimize Code?

* enable advanced features

^• impossible without optimization
• maybe show Pyramid of user happiness
• maybe talk about 0fps board game example

![right 33%](advancesfeatures.jpg)

---

# ⚡️Premature Optimization⚡️

> We should forget about small efficiencies, say about 97% of the time: _premature optimization is the root of all evil_. Yet we should not pass up our opportunities in that critical 3%."

Donald Knuth

--- 

# ⚡️Premature Optimization⚡️

We want to write:

1. understandable, safe and testable code (DRY, KISS, etc.)
2. optimize as _needed_

* programming time is 💰
* faster code often more complex (💰)
* -> pick your battles


---

## What to Optimize for?

* CPU cycles 
* loading times, battery power, fps

![inline](cpuprofiler.png)

---

## What to Optimize for?

* memory
* how long our stays in background mode before being killed by iOS
* fitting your project on small mobile devices (Watch!)

![inline](allocations.png)

---

## What to Optimize for?

* memory and cpu optimization can sometimes benefit from each other, example:

```swift
struct Element {
  let n: Int
  // more variables to fill to certain size
}

let array: [Element] = // ...

measure {
  _ = array.reduce(0) { $0 + $1.n }
}
```

---

## What to Optimize for?

* memory and cpu optimization can sometimes benefit from each other 

![inline 100%](memoryPerformance.png)

^^Remember: all test-cases have the same number of operations!

---

## Explanation L1/L2-Caches


![inline](/Users/konrad/Desktop/l2cache.png)


---

## What to Optimize for?

* sometimes cpu ⚡️ memory

* e.g. all kinds of caches, simplest example:

```swift
lazy var lazilyCalculated: Object = {
  return makeHeavyObject()
}

// vs

var lazilyCalculated: Object {
  return makeHeavyObject()
}
```

---

## Optimization Loop

![inline](optimizationLoop.png)


---

## Unit Tests!

```swift
func heavyCalculation(input: Input) -> Output {
  // lot's of code
  // ⟲
}
```

* unit test `Input -> Output` for correctness
* optimize internal algorithm iteratively for performance 


---

![](starsBack.png)

# ✨✨ Main Example: ✨✨

* large database of stars with many columns
* 8000 x ⭐️  ~ 1.8 MB 🙂

* 120000 x ⭐️  ~ 27 MB 😐
* 2.5mil x ⭐️  ~ 560 MB 😣

^•visible with naked eye
• Hipparcos catalogue 
• Tycho2 - db of 2.5 million brightest (1993)


---

# Size vs Stride

* `MemoryLayout<Star3D>.size // 217`
* `MemoryLayout<Star3D>.stride // 224`

![inline](strideVsSize.png)

* $$ n * Stride(type) = Size(Array) $$

---

![](starsBack.png)

## Basic (Unoptimized?) Struct

```swift
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

MemoryLayout<StarData>.stride // 208
```

---

![](starsBack.png)

## How big are Ints?

* `print(Int8.max) // 127`
* `print(Int16.max) // 32767`
* `print(Int32.max) // 2147483647`
* `print(Int.max) // 9223372036854775807`

* when designing the struct we already noticed we never need more then `Int32` to fit all stars

^as we all remember Int sizes use different amount of bytes

---

![](starsBack.png)

## Basic (Unoptimized?) Struct
  
```swift, [.highlight: 4-6]
struct StarData {
    let right_ascension: Float
    let declination: Float
    let hip_id: Int32?         // 4
    let hd_id: Int32?          // 4
    let hr_id: Int32?          // 4
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
```

^looks optimal, used the right integer sizes
^with these sizes, let's look at more detail

---

![](starsBack.png)

## Float

```swift, [.highlight: 2-3, 15]
struct StarData {
    let right_ascension: Float   // 4
    let declination: Float       // 4
    let hip_id: Int32?           // 4
    let hd_id: Int32?            // 4
    let hr_id: Int32?            // 4
    let gl_id: String?
    let bayer_flamstedt: String?
    let properName: String?
    let distance: Double
    let rv: Double?
    let mag: Double
    let absmag: Double
    let spectralType: String?
    let colorIndex: Float?       // 4
}
```

---

![](starsBack.png)

## Double

```swift, [.highlight:  10-13]
struct StarData {
    let right_ascension: Float   // 4
    let declination: Float       // 4
    let hip_id: Int32?           // 4
    let hd_id: Int32?            // 4
    let hr_id: Int32?            // 4
    let gl_id: String?
    let bayer_flamstedt: String?
    let properName: String?
    let distance: Double         // 8
    let rv: Double?              // 8
    let mag: Double              // 8
    let absmag: Double           // 8
    let spectralType: String?
    let colorIndex: Float?       // 4
}
```

---

![](starsBack.png)

## String

```swift, [.highlight:  7-9, 14]
struct StarData {
    let right_ascension: Float   // 4
    let declination: Float       // 4
    let hip_id: Int32?           // 4
    let hd_id: Int32?            // 4
    let hr_id: Int32?            // 4
    let gl_id: String?           // 24
    let bayer_flamstedt: String? // 24
    let properName: String?      // 24
    let distance: Double         // 8
    let rv: Double?              // 8
    let mag: Double              // 8
    let absmag: Double           // 8
    let spectralType: String?    // 24
    let colorIndex: Float?       // 4
}
```

---

![](starsBack.png)

## Quick Summing up
  
* Float, Int32 : 4 Byte

* Double: 8 Byte

* String: 24 Byte

* `24*4 + 8*4 + 4*6 = 152`

* 152 != 208 

* 😳 

--- 

![](starsBack.png)

## Our Favorite Swift Type 

```swift
enum Optional<Wrapped> {
    case none
    case some(Wrapped)
}
```

* Adds 1 Byte

```swift
MemoryLayout<Int>.size     // 8
MemoryLayout<Int?>.size    // 9
MemoryLayout<String>.size  // 24
MemoryLayout<String?>.size // 25
```

---

![](starsBack.png)

## Removing Optionals

* let's use default value instead of nil (`-1`,`""`)

* stay safe by using `private` members and public getters

```swift
public func getHipId() -> Int? {
    return hip_id != -1 ? hip_id : nil
}
```

^make sure -1 is never used,
in my case I actually store it as a static variable and compare the variable


---

![](starsBack.png)

## Struct without Optionals

```swift
struct StarData {
    let right_ascension: Float
    let declination: Float
    let hip_id: Int32
    let hd_id: Int32
    let hr_id: Int32
    let gl_id: String
    let bayer_flamstedt: String
    let properName: String
    let distance: Double
    let rv: Double
    let mag: Double
    let absmag: Double
    let spectralType: String
    let colorIndex: Float?
}

MemoryLayout<StarData>.stride // 160
```


---

![](starsBack.png)

## Struct without Optionals

* wait, what?

* $$ 208 - 160 \neq 9 * 1 $$

* we removed 9 Optionals and gained 48 Byte 🤔



--- 

![](starsBack.png)

# Alignment (C Knowledge to the Rescue!)

* modern CPUs lay out data types so memory access is fast

* each type has a _memory aligment_
  1. `char` can start anywhere
  2. `short` can start on even bytes
  3. `float` can start on 4/8/12/16/...
  4. ...


--- 

![](starsBack.png)

# Alignment (Swift)

```swift
MemoryLayout<Int8>.alignment             // 1
MemoryLayout<Int16>.alignment            // 2
MemoryLayout<Float>.alignment            // 4
MemoryLayout<Double>.alignment           // 8
MemoryLayout<Optional<Double>>.alignment // 8
MemoryLayout<String>.alignment           // 8
MemoryLayout<Optional<String>>.alignment // 8
```

--- 

![](starsBack.png)

# Padding

```swift
struct User {
  let firstName: String   // 24Byte starts at 0
  let middleName: String? // 25Byte starts at 24
                          // padding of 7 Byte
  let lastname: String    // 24Byte starts at 56
}
MemoryLayout<User>.stride // 80
```

![inline 120% left](paddingGraphic.png)

--- 

![](starsBack.png)

# Bad Alignment Example

```swift
struct BadAligned {
    let isHidden: Bool
    let size: Double
    let isInteractable: Bool
    let age: Int
}
MemoryLayout<BadAligned>.stride // 32Byte
```
![left inline 100%](badPadding.png)

--- 

![](starsBack.png)

# Better Alternative (saves 25%)

```swift
struct WellAligned {
    let isHidden: Bool
    let isInteractable: Bool
    let height: Double
    let age: Int
}
print(MemoryLayout<WellAligned>.stride) // 24
```

![left inline 100%](goodPadding.png)

^it's nice isn't it?
Like playing tetris ;)


--- 

![](starsBack.png)

# Aligned StarData

* 208 -> 152 (Optionals + Alignment)

```swift
struct StarData {
    let right_ascension: Float
    let declination: Float
    let hip_id: Int32
    let hd_id: Int32
    let hr_id: Int32
    let colorIndex: Float
    let distance: Double
    let rv: Double
    let mag: Double
    let absmag: Double
    let gl_id: String
    let bayer_flamstedt: String
    let properName: String
    let spectralType: String
}

MemoryLayout<StarData>.stride   // 152
```

---

![](starsBack.png)

## Use Domain Knowledge

```swift
struct StarData {
    // ...                         56 Bytes of Float/Int
    let gl_id: String           // 24
    let bayer_flamstedt: String // 24
    let properName: String      // 24
    let spectralType: String    // 24
}
```

* largest piece are the strings

* turns out many strings are empty

* only 146 stars have proper names

* 3801 unique Gliese IDs

* 3064 Bayer Flamstedt Designations

* 4307 different spectral types (could be cleaned up)

---

![](starsBack.png)

## Spare Strings into Separate Dictionaries

* during loading of database, index unique instances of strings

* create nice accessors to hide implementation detail

```swift
func getGlId() -> String? {
    return gl_id != -1 ? DB.glIds[Int(gl_id)] : nil
}
```


---

![](starsBack.png)

## Spare Strings into Separate Dictionaries

```swift, [.highlight:  12-15, 18]
struct StarData {
    let right_ascension: Float
    let declination: Float
    let hip_id: Int32
    let hd_id: Int32
    let hr_id: Int32
    let colorIndex: Float
    let distance: Double
    let rv: Double
    let mag: Double
    let absmag: Double
    let gl_id: Int16
    let bayer_flamstedt: Int16
    let properName: Int16
    let spectralType: Int16
}

MemoryLayout<StarData>.stride   // 64
```

* are we done?

---

![](starsBack.png)

## Alignment One More Time

```swift
struct StarData {
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

MemoryLayout<StarData>.stride   // 56
```

---

![](starsBack.png)

## Final Result

![inline 100%](diagram.png)

^looks great but
again, this is not about the numbers
but about getting more out of our app -> more stars

---
## Premature optimization is the root of all evil…

Examples (when not to use what we just learned):

* set of 20 users ⚠️
* media library of 1000 movies ⚠️
* Server-Side Swift with > 10^6 entries ✅
* procedurally generated content in a game ✅
* points of interest in MapKit ✅

---

## Extra: Swift Compiler

* we can also apply the same steps to swift project compilation time
* measure compilation of each function and sort result

```bash
xcodebuild -project App.xcproj -scheme App clean build
 OTHER_SWIFT_FLAGS="-Xfrontend -debug-time-function-bodies" | 
 grep "[0-9][0-9]\.[0-9]*ms" | sort -nr > culprits.txt
```

```
430.23ms	../Pods/SwiftyBeaver/Sources/AES256CBC.swift:356:18	instance method decrypt(block:)
267.29ms	../LooC/ContrastTestViewModel.swift:99:22	instance method adjustBrightnessGradually()
262.38ms	../LooC/HistoryViewModel.swift:215:18	instance method graphForNearVision(tests:firstT:lastT:)
250.10ms	../LooC/HistoryViewModel.swift:276:10	instance method generateFakeTests()
224.70ms	../LooC/HistoryViewModel.swift:221:41	(closure)
```

---
## Server-Side Swift Example

* getting lots of data into a small machine works especially well on servers

* example: https://github.com/Bersaelor/StarsOnKitura / https://starsonkitura.eu-de.mybluemix.net


---
## What did we learn today?

* pick your battles wisely!

* play Tetris with struct `var`s when necessary

* know your domain to utilize its properties


---
## Links

* Premature Optimization http://wiki.c2.com/?PrematureOptimization
* The Lost Art of C Structure Packing http://www.catb.org/esr/structure-packing/
* Writing High-Performance Swift Code https://github.com/apple/swift/blob/master/docs/OptimizationTips.rst
* Swift Array Design https://github.com/apple/swift/blob/master/docs/Arrays.rst
* KDTree / Stars at Functional Swift https://www.youtube.com/watch?v=CwcEjxRtn18


--- 

## Thank you

* github.com/Bersaelor
* twitter.com/bersaelor