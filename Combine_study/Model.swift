//
//  Model.swift
//  Combine_study
//
//  Created by 여원구 on 2023/03/19.
//

import Foundation

struct MyModel {
    
    var title: String?
    var detail: String?
    
    init(title: String? = nil, detail: String? = nil) {
        self.title = title
        self.detail = detail
    }
}
