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

        let appId = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String

        let params = [
            "api_key": apiKey,
            "secret": secret,
            "resource": appId,
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

}

private extension UIImage {

    /* UIImage.jpegData() returns nil for non-CGImage backed UIImages, for example those generated from Core Image.
     This method is safer as it will attempt to re-draw the image to a new context if necessary.
    */
    func safeJPEGData(compressionQuality: CGFloat) -> Data? {
        guard cgImage == nil else {
            return self.jpegData(compressionQuality: compressionQuality)
        }

        guard let ciImage = ciImage,
            let cgImage = CIContext(options: nil).createCGImage(ciImage, from: ciImage.extent)
            else { return nil }

        return UIImage(cgImage: cgImage).jpegData(compressionQuality: compressionQuality)
    }

}

private extension MultipartFormData {

    func append(_ string: String, withName name: String) {
        guard let data = string.data(using: .utf8) else { fatalError() }
        append(data, withName: name)
    }

    func append(_ int: Int, withName name: String) {
        var aInt = int
        let data = Data(bytes: &aInt, count: MemoryLayout.size(ofValue: aInt))
        append(data, withName: name)
    }

}
