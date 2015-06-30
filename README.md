# HttpManager

This is a simple HTTP library. I'm doing this as a little experiment and a learning experience. Currently able to execute GET and POST requests with parameters, custom headers and post form data.

<br>

## Install

##### [CocoaPods](http://cocoapods.org/) (< v0.36)
- Create a `Podfile`.
- Add the line, `pod 'HttpManager', :git => 'https://github.com/Isuru-Nanayakkara/HttpManager.git'`.
- Run `pod install`.
- Add `import HttpManager` to the files where you want to use the library. 


##### Manually
- Add the *HttpManager.swift* file to your project.

<br>

## Usage

### GET
```swift
let url = "http://httpbin.org/get"

HttpManager.get(url).execute({ (result, error) -> () in
    println(result)
})
```

### POST
```swift
let url = "http://httpbin.org/post"

HttpManager.post(url).execute({ (result, error) -> () in
    println(result)
})
```

#### Parameters
```swift
let url = "http://httpbin.org/get"
let params = ["show_env": 1]

HttpManager.get(url).parameters(params).execute({ (result, error) -> () in
    println(result)
})
```

#### Custom Headers
```swift
let url = "http://httpbin.org/headers"
let header = ["X-Custom-Header": "Hello World"]

HttpManager.get(url).headers(header).execute({ (result, error) -> () in
    println(result)
})
```

#### Form Data
```swift
let url = "http://httpbin.org/post"
let bodyData = ["now": NSDate()]

HttpManager.post(url).data(bodyData).execute({ (result, error) -> () in
    println(result)
})
```