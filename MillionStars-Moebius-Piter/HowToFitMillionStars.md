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

## Optimization Steps

![inline](optimizationLoop.png)

* unit tests features so we don't break them during the loop


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

## Intermission: Swift Compiler

* we can also apply the same steps to swift project compilation time

```
xcodebuild -project App.xcproj -scheme App clean build
 OTHER_SWIFT_FLAGS="-Xfrontend -debug-time-function-bodies" | 
 grep "[0-9][0-9]\.[0-9]*ms" | sort -nr > culprits.txt
```

---

![left](large dataset.png)

## Main Example


* large database of stars
* many columns
* ` =<Star3D>.size`
* `// 217`
* `MemoryLayout<Star3D>.stride`
* `// 224`
* 8000 x ⭐️  ~ 1.8 MB 🙂

* 120000 x ⭐️  ~ 27 MB 😐
* 2.5mil x ⭐️  ~ 560 MB 😣

^•visible with naked eye
• Hipparcos catalogue 
• Tycho2 - db of 2.5 million brightest (1993)

---

## Seperate Spatial Data from Rest

```
struct Star3D {
    let dbID: Int32
    let x: Float
    let y: Float
    let z: Float
    let starData: Box<StarData>?
}
```

* only x/y/z needed for spatial tree structure
* significantly reduces size of tree and increases tree lookup performance
* `Box` is `Unmanaged` / `Unretained` to speed up tree structure 🚨

![right 130%](kdtree.png)

---

![left 110%](basicStruct.png)
## Basic (Unoptimized?) Struct

* Overall stride of 208 Byte
  
* actually, this was _sort of_ optimized, as

* `print(Int8.max) // 127`
* `print(Int16.max) // 32767`
* `print(Int32.max) // 2147483647`
* `print(Int.max) // 9223372036854775807`

^as we all remember Int sizes use different amount of bytes
looks optimal, used the right integer sizes
with these sizes, let's look at more detail

---

![left 140%](tally.png)

## Quick Check

* `print(MemoryLayout<X>.size)`
  
* Float, Int32 : 4 Byte

* Double: 8 Byte

* String: 24 Byte

* `24*4 + 8*4 + 4*6 = 152`

* 152 != 208 

* 😳 

--- 

## Our Favorite Swift Type 

```
enum Optional<Wrapped> {
    case none
    case some(Wrapped)
}
```

* Adds 1 Byte
![inline 100%](memorysize of optional.png)

---

## No Optionals

* let's use default value instead of nil (`-1`,`""`)

* still be safe by using `private` members and public getters

```
public func getHipId() -> Int? {
    return hip_id != -1 ? hip_id : nil
}
```

^make sure -1 is never used,
in my case I actually store it as a static variable and compare the variable


---

![left 90%](withoutOptionals.png)

## Struct without Optionals

* wait, what?

* `208 - 160 != 9 * 1`

* we removed 9 Optionals and gained 48 Byte 🤔



--- 

# Alignment (C Knowledge to the Rescue!)

* modern CPUs lay out data types so memory access is fast

* each type has a _memory aligment_
  1. `char` can start anywhere
  2. `short` can start on even bytes
  3. `float` can start on 4/8/12/16/...
  4. ...


--- 

# Alignment (Swift)

![inline](alignementSwift.png)

--- 

# Padding

![inline](padding.png)

![inline 120%](paddingGraphic.png)

--- 

# Bad Alignment Example

```
struct BadAligned {
    let isHidden: Bool
    let size: Double
    let isInteractable: Bool
    let age: Int
}
print(MemoryLayout<BadAligned>.stride) // 32Byte
```
![left inline 100%](badPadding.png)

--- 

# Better Alternative
```
struct WellAligned {
    let isHidden: Bool
    let isInteractable: Bool
    let height: Double
    let age: Int
}
print(MemoryLayout<WellAligned>.stride) // 24Byte
```
![left inline 100%](goodPadding.png)

^it's nice isn't it?
Like playing tetris ;)


--- 

![left 82%](alignedStarData.png)

# Aligned StarData

* Optionals + Alignment: 

* 208 -> 152


---

![left 82%](alignedStarDataAnnotated.png)

## Use Domain Knowledge

* biggest chunk of data is the strings!

* turns out many strings are empty

* only 146 stars have proper names

* 3801 unique Gliese IDs

* 3064 Bayer Flamstedt Designations

* 4307 different spectral types (could be cleaned up)

---

![left 82%](starDataIndexed.png)

## Spare Strings into Separate Dictionaries

* during loading of database, index unique instances of strings

* create nice accessors to hide implementation detail

```
func getGlId() -> String? {
    return gl_id != -1 ? DB.glIds[Int(gl_id)] : nil
}
```

* are we done?

---

## Alignment One More Time

![inline](finalStruct.png)

---

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