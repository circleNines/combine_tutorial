//
//  CodableModel.swift
//  Combine_study
//
//  Created by 여원구 on 2023/04/16.
//

import Foundation

struct CodableModel: Codable {
    
    var list: [ListModel]?

    enum CodingKeys: String, CodingKey {
        case list
    }
    
    init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        self.list = try? container.decode([ListModel].self, forKey: .list)
    }
}

struct ListModel: Codable {
    var name: String?
    var age: Int?
    
    enum CodingKeys: String, CodingKey {
        case name
        case age
    }
    
    init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        self.name = try? container.decode(String.self, forKey: .name)
        self.age = try? container.decode(Int.self, forKey: .age)
        
        //print("name: \(name), age: \(age)")
    }

}
