# Duration [![Build Status](https://travis-ci.org/MaciejGad/Duration.svg?branch=master)](https://travis-ci.org/MaciejGad/Duration)
ISO 8601 duration implementation for Swift using Codable.

This micro-framework should help with handling duration written using the ISO 8601 standard. It allows parsing a string like "P3Y6M4DT12H30M5S" to TimeInterval. More about ISO 8601 standard you can read in wiki https://en.wikipedia.org/wiki/ISO_8601#Durations


# Usage 
We will assume that you have a JSON like this:

```json
{
  "duration": "P3Y6M4DT12H30M5S"
}
```

then you can create your own structure:

```swift
import ISO8601Duration

struct Box: Codable {
  let duration: Duration
}
```

add load data in a typical way:

```swift
let data =  Data(bytes: "{\"duration\":\"P3Y6M4DT12H30M5S\"}".utf8) //load you data
let decoder = JSONDecoder()
let box = try decoder.decode(Box.self, from: data)
print(box.duration.timeInterval) //110615405.0
```

# Installation

Use the [CocoaPods](http://github.com/CocoaPods/CocoaPods).

Add to your Podfile
>`pod 'ISO8601Duration'`

and then call

>`pod install`

and import 

>`import ISO8601Duration`
