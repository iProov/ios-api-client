# iProov iOS API Client

## Introduction

The iProov iOS API Client is a simple wrapper for the [iProov REST API v2](https://secure.iproov.me/docs.html) written in Swift and using [Alamofire](https://github.com/Alamofire/Alamofire). We also have an Android API client available [here](https://github.com/iProov/android-api-client).

## Important security notice

In production, the iProov REST API should only ever be called directly from your back-end, however this library is designed to help you with debugging/evaluating the [iProov iOS SDK](https://github.com/iProov/ios), to get up-and-running quickly with a pure on-device demo.

Use of the iOS API Client requires providing it with your API secret. **You should never embed your API secret within a production app**. 

...Although, if by any chance you happen to use Swift on your [back](https://vapor.codes/)-[end](https://perfect.org/) then you can probably use this code on your server, with just a few modifications (for example, you will need to handle images without UIKit).

## Installation

### Swift Package Manager

We recommend the iOS API Client is installed as a Swift Package:

1. Select `File` → `Add Package Dependencies…` in the Xcode menu bar.

2. Search for the iOS API Client package using the following URL:

	```
	https://github.com/iProov/ios-api-client
	```
	
3. Set the _Dependency Rule_ to be _Up to Next Major Version_.
	
4. Click _Add Package_ to add the iOS API Client dependency to your Xcode project and to your app target, and then click again to confirm.

### Cocoapods

The iOS API Client can also be installed as a Cocoapods dependency. Simply add the following line to your Podfile:

```
pod 'iProovAPIClient'
```

And then run `pod install`.

## Supported functionality

- `getToken()` - Get an enrol/verify token.
- `enrolPhoto()` - Once you have an enrolment token, you can enrol a photo against it.
- `validate()` - Validates an existing token.
- `enrolPhotoAndGetVerifyToken()` - A helper function which chains together `getToken()` for the enrolment token, `enrolPhoto()` to enrol the photo, and then `getToken()` for the verify token, which you can then use to launch the SDK.

## Example

Example of using iProov API Client together with iProov to get a verify token for an existing user and then launch the iProov SDK to perform the verification using Genuine Presence Assurance:

```swift
import iProovAPIClient
import iProov

let apiClient = APIClient(baseURL: "https://eu.rp.secure.iproov.me",
                          apiKey: "{{ Your API key }}",
                          secret: "{{ Your API secret }}")

apiClient.getToken(assuranceType: .genuinePresence,
                   type: .verify,
                   userID: "user@example.com") { result in

    switch result {
    case let .success(token):

        IProov.launch(streamingURL: "https://eu.rp.secure.iproov.me",
                      token: token) { status in
            print(status)
        }

    case let .failure(error):
        print(error)
    }
}
```

## License

The iProov iOS API Client is licensed under the BSD-3 license.
