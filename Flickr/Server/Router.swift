//
//  Router.swift
//  Flickr
//
//  Created by lawliet on 2020/9/30.
//

import Foundation

struct Router {
    static let apiKey = ""
    static let baseURL: String = ""
    
    static func getSearchUrl(text: String, perPage: String, page: Int?) -> String {
        if let page = page {
            return "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(text)&per_page=\(perPage)&page=\(page)&format=json&nojsoncallback=1"
        } else {
            return "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(text)&per_page=\(perPage)&format=json&nojsoncallback=1"
        }
    }
    
    static func getImageUrl(server: String, id: String, secret: String) -> String {
//        https://live.staticflickr.com/65535/50410587672_1654e064d3.jpg
        return "https://live.staticflickr.com/\(server)/\(id)_\(secret).jpg"
    }
    
}
