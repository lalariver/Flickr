//
//  ViewModel.swift
//  Flickr
//
//  Created by lawliet on 2020/9/30.
//

import Foundation

class SearchViewModel {
    public func changeTextField(text: String?, bool: Bool) -> Bool {
        guard text != "", bool != false else {
            return false
        }
        return true
    }
}


