//
//  SearchJsonModel.swift
//  Flickr
//
//  Created by lawliet on 2020/10/1.
//

import Foundation
import Alamofire

// MARK: - ResultJSONModel
struct ResultJSONModel: Codable {
    var photos: Photos
    let stat: String
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responsePhotos { response in
//     if let photos = response.result.value {
//       ...
//     }
//   }

// MARK: - Photos
struct Photos: Codable {
    let page, pages, perpage: Int
    let total: String
    var photo: [Photo]
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responsePhoto { response in
//     if let photo = response.result.value {
//       ...
//     }
//   }

// MARK: - Photo
struct Photo: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - Alamofire response handlers

extension DataRequest {
    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else { return .failure(error!) }

            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }

            return Result { try newJSONDecoder().decode(T.self, from: data) }
        }
    }

    @discardableResult
    fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
    }

    @discardableResult
    func responseResultJSONModel(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<ResultJSONModel>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
