//
//  ResultViewModel.swift
//  Flickr
//
//  Created by lawliet on 2020/10/3.
//

import Foundation

class ResultViewModel {
    func getLoadMoreSearchModel(searchModel: SearchModel) -> SearchModel {
        if var page = searchModel.page {
            page += 1
            return SearchModel(searchText: searchModel.searchText, perPage: searchModel.perPage, page: page)
        } else {
            return SearchModel(searchText: searchModel.searchText, perPage: searchModel.perPage, page: 2)
        }
    }
}
