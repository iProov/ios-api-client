# iProov API Swift Client

## 👋 Introduction

The iProov API Swift Client is a simple wrapper for the [iProov REST API](https://secure.iproov.me/docs.html) written in Swift and using [Alamofire](https://github.com/Alamofire/Alamofire) & [SwiftyJSON](https://github.com/SwiftyJSON/Alamofire-SwiftyJSON) for the HTTP networking and JSON serialization/deserialization.

v7 of the [iProov SDK](https://github.com/iProov/ios) removed the built-in functionality to obtain tokens from the core SDK. This library therefore provides that missing functionality as a separate library, and also exposes additional functionality such as the ability to enrol photos.

## ⚠️ Important security notice

The iProov REST API should only called directly from your back-end, however this library is designed to help you with debugging/evaluating the [iProov iOS SDK](https://github.com/iProov/ios), to get up and running quickly with a pure on-device demo.

Use of the iProov API Client requires providing it with your API secret. **You should never embed your API secret within a production app**. 

## 🛠 Supported functionality

- **`getToken()`** - Get an enrol/verify token
- **`enrolPhoto()`** - Once you have an enrolment token, you can enrol a photo against it
- **`validate()`** - Validates an existing token
- **`enrolPhotoAndGetVerifyToken()`** - A helper function which chains together `getToken()` for the enrolment token, `enrolPhoto()` to enrol the photo, and then `getToken()` for the verify token, which you can then use to launch the SDK.