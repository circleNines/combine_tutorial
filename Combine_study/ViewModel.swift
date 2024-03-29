//
//  ViewModel.swift
//  Combine_study
//
//  Created by 여원구 on 2023/03/19.
//

import Foundation
import Combine

class TableViewModel: ObservableObject {
    
    // 추가 될 Data가 어디에 붙을지 정해주는 Type
    enum AddingType {
      case prepend
      case append
    }
    
    private var tempList: [MyModel] = []    // Default Array
    @Published var list: [MyModel] = []     // Published Array
    
    var dataUpdateAction = PassthroughSubject<AddingType, Never>() // <Output Type, Failure Type>
    
    init() {
        print("TableViewModel init!")
        
        let fileName = "person"
        let extensionType = "json"
        guard let filePaths = Bundle.main.url(forResource: fileName, withExtension: extensionType) else { return }
        
        do {
            // json parsing
            let data = try Data(contentsOf: filePaths)
            guard let json = try? JSONDecoder().decode(CodableModel.self, from: data) else { return }
            json.list?.forEach({ tempList.append(MyModel(title: $0.name, detail: String($0.age ?? 0))) })
            
            self.list = tempList
        }catch {
            print("error === \(error.localizedDescription)")
        }
    }
    
    // added to prepend
    func prependData(item: MyModel) {
        print(#fileID, #function, #line, "")
        list.insert(item, at: 0)
        self.dataUpdateAction.send(.prepend)
    }
    
    // added to append
    func appendData(item: MyModel) {
        print(#fileID, #function, #line, "")
        list.append(item)
        self.dataUpdateAction.send(.append)
    }
}

// 정보 입력 ViewModel
class InputViewModel: ObservableObject {
    @Published var enableBtn: Bool = false
    
    init() {
        print("InputViewModel init!")
    }
}
