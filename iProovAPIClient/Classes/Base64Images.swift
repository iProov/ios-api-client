//
//  Base64Images.swift
//  iProovAPIClient
//
//  Created by Jonathan Ellis on 03/06/2019.
//

import UIKit
import SwiftyJSON

extension JSON {

    var base64EncodedImage: UIImage? {
        guard let string = string else { return nil }
        return UIImage(base64String: string)
    }

    var base64EncodedImageValue: UIImage {
        return base64EncodedImage ?? UIImage()
    }

}

extension UIImage {

    convenience init?(base64String: String) {
        guard let data = Data(base64Encoded: base64String) else { return nil }
        self.init(data: data)
    }

    var base64String: String {
        return jpegData(compressionQuality: 0.9)!.base64EncodedString()
    }

}
