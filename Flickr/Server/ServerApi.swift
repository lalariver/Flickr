//
//  ServerApi.swift
//  Flickr
//
//  Created by lawliet on 2020/10/1.
//

import Foundation

final class ServerApi {
    static func searchImage(searchModel: SearchModel, success: @escaping ((_ searchJsonModel: ResultJSONModel) -> Void), failure: @escaping ((_ error: Error) -> Void)) {
        
        let urlStr = Router.getSearchUrl(text: searchModel.searchText, perPage: searchModel.perPage, page: searchModel.page)
        print("url: \(urlStr)")
        APITool.request(urlStr: urlStr, method: .get, parameters: nil, successHandle: success, failureHandle: failure)
    }
}
