//
//  APIClient.swift
//  iProovAPIClient
//
//  Created by Jonathan Ellis on 03/06/2019.
//

// ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️
//    THIS CODE IS PROVIDED FOR DEMO PURPOSES ONLY AND SHOULD NOT BE USED IN
//  PRODUCTION! YOU SHOULD NEVER EMBED YOUR CREDENTIALS IN A PUBLIC APP RELEASE!
//      THESE API CALLS SHOULD ONLY EVER BE MADE FROM YOUR BACK-END SERVER
// ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️

import Foundation
import Alamofire
import Alamofire_SwiftyJSON

private let appID = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String

public enum ClaimType: String {
    case enrol, verify
}

public enum APIClientError: Error {
    case invalidImage, noToken
}

public class APIClient {

    private let baseURL: String
    private let apiKey: String
    private let secret: String

    public enum PhotoSource: String {
        case electronicID = "eid"
        case opticalID = "oid"
    }

    public init(baseURL: String = "https://eu.rp.secure.iproov.me/api/v2", apiKey: String, secret: String) {
        #warning("You should never embed your API client secret in client code.")
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.secret = secret
    }

    public func getToken(type: ClaimType, userID: String, success: @escaping (_ token: String) -> Void, failure: @escaping (Error) -> Void) {
        
        let url = String(format: "%@/claim/%@/token", baseURL, type.rawValue)

        let params = [
            "api_key": apiKey,
            "secret": secret,
            "resource": appID,
            "client": "ios",
            "user_id": userID
        ]

        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding(), headers: nil)
            .validate()
            .responseSwiftyJSON { (response) in

            switch response.result {
            case let .success(json):

                if let token = json["token"].string {
                    success(token)
                } else {
                    failure(APIClientError.noToken)
                }

            case let .failure(error):
                failure(error)

            }
        }

    }

    public func enrolPhoto(token: String, image: UIImage, source: PhotoSource, success: @escaping (_ token: String) -> Void, failure: @escaping (Error) -> Void) {

        let url = String(format: "%@/claim/enrol/image", baseURL)

        guard let jpegData = image.safeJPEGData(compressionQuality: 1.0) else {
            failure(APIClientError.invalidImage)
            return
        }

        Alamofire.upload(multipartFormData: { (multipartFormData) in

            multipartFormData.append(self.apiKey, withName: "api_key")
            multipartFormData.append(self.secret, withName: "secret")
            multipartFormData.append(0, withName: "rotation")
            multipartFormData.append(token, withName: "token")
            multipartFormData.append(jpegData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")

        }, to: url, encodingCompletion: { (encodingResult) in

            switch encodingResult {
            case let .success(request, _, _):

                request.validate().responseSwiftyJSON(completionHandler: { (response) in

                    switch response.result {
                    case let .success(json):

                        if let token = json["token"].string {
                            success(token)
                        } else {
                            failure(APIClientError.noToken)
                        }

                    case let.failure(error):
                        failure(error)
                    }

                })

            case let .failure(error):

                failure(error)

            }

        })

    }

    public func validate(token: String, userID: String, success: @escaping (ValidationResult) -> Void, failure: @escaping (Error) -> Void) {

        let url = String(format: "%@/claim/verify/validate", baseURL)

        let params = [
            "api_key": apiKey,
            "secret": secret,
            "user_id": userID,
            "token": token,
            "ip": "127.0.0.1",
            "client": appID
        ]

        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding(), headers: nil)
            .validate()
            .responseSwiftyJSON { (response) in

                switch response.result {
                case let .success(json):
                    let validationResult = ValidationResult(json: json)
                    success(validationResult)

                case let .failure(error):
                    failure(error)

                }
        }
    }

}

public extension APIClient {

    // This helper function chains together the 3 calls needed to enrol photo and get a token to iProov against:
    func enrolPhotoAndGetVerifyToken(userID: String, image: UIImage, source: PhotoSource, success: @escaping (_ token: String) -> Void, failure: @escaping (Error) -> Void) {

        getToken(type: .enrol, userID: userID, success: { (token) in
            self.enrolPhoto(token: token, image: image, source: source, success: { (token) in
                self.getToken(type: .verify, userID: userID, success: success, failure: failure)
            }, failure: failure)
        }, failure: failure)

    }

}

private extension MultipartFormData {

    func append(_ string: String, withName name: String) {
        guard let data = string.data(using: .utf8) else { fatalError() }
        append(data, withName: name)
    }

    func append(_ int: Int, withName name: String) {
        let data = withUnsafeBytes(of: int) { Data($0) }
        append(data, withName: name)
    }

}
