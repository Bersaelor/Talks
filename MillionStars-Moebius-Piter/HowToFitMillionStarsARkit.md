build-lists: true

# How to fit a million ✨ into ARKit

#### pretty picture

---

## How I got here

* picture of KDTree
* problem
* solution and results

^why am I talking about optimization today
thats what we want to talk about:

---
## Content

* general points on optimization
* example problem
* Swift Struct memory deep dive
* apply to ARKit
* pretty results (hopefully)

---

## Why Optimize Code?

* loading bar image/animation
* improve quality
  * graphics
	* sound
	* AI ...
* enable advanced features
* battery power (image)

^• happier users
• same but better -> happier users
• impossible without optimization
• maybe show Pyramid of user happiness
• maybe talk about 0fps board game example
• maybe examples for every item

---

## What to Optimize?

* cpu cycles (pic)
* memory (pic)

^sometimes synergy, sometimes against each other

---

### Intermission: Swift Compiler

```
xcodebuild -project App.xcproj -scheme App clean build
 OTHER_SWIFT_FLAGS="-Xfrontend -debug-time-function-bodies" | 
 grep "[0-9][0-9]\.[0-9]*ms" | sort -nr > culprits.txt
```

---

## How?

* profile ->
* identify problem ->
* hypothesis -> 
* profile again

(pics)

^Unit tests immensely helpful making sure that we don't break features

---

# 🚨 (or pic about cost)

1. Understandable, safe and testable code (DRY, KISS etc)
2. Optimize as _needed_

* faster code often more complex (💰)
* pick your battles

---

# ⚡️Premature Optimization⚡️

funny pic

^example of PO in code review

```

```


---

## Style Tipps

* computed `var` vs `func getValue()`
* note complexity in method documentation

---

* This works with both local files and web images
* You don’t _have_ to drag the file, you can also type the Markdown yourself if you know how

![left,filtered](http://deckset-assets.s3-website-us-east-1.amazonaws.com/colnago1.jpg)