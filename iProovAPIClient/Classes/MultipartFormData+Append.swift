//
//  MultipartFormData+Append.swift
//  iProovAPIClient
//
//  Created by Jonathan Ellis on 18/06/2019.
//

import Foundation
import Alamofire

extension MultipartFormData {

    func append(_ string: String, withName name: String) {
        guard let data = string.data(using: .utf8) else { fatalError() }
        append(data, withName: name)
    }

    func append(_ int: Int, withName name: String) {
        let data = withUnsafeBytes(of: int) { Data($0) }
        append(data, withName: name)
    }

}
