//
//  ViewModel.swift
//  Combine_study
//
//  Created by 여원구 on 2023/03/19.
//

import Foundation
import Combine

class ViewModel: ObservableObject {
    
    // 추가 될 Data가 어디에 붙을지 정해주는 Type
    enum AddingType {
      case prepend
      case append
    }
    
    var prependCount: Int = 0 // 앞에 붙는 new Data 갯수
    var appendCount: Int = 0  // 뒤에 붙는 new Data 갯수
    
    var dataUpdateAction = PassthroughSubject<AddingType, Never>() // <Output Type, Failure Type>

    private var tempList: [MyModel] = [] // default array
    @Published var list: [MyModel] = []
    
    init() {
        print("ViewModel init!")
        
        let fileName = "person"
        let extensionType = "json"
        guard let filePaths = Bundle.main.url(forResource: fileName, withExtension: extensionType) else { return }
        
        do {
            let data = try Data(contentsOf: filePaths)
            guard let json = try? JSONDecoder().decode(CodableModel.self, from: data) else { return }
            json.list?.forEach({ tempList.append(MyModel(title: $0.name, detail: String($0.age ?? 0))) })
            self.list = tempList
        }catch {
            print("error === \(error.localizedDescription)")
        }
    }
    
    func prependData() {
        print(#fileID, #function, #line, "")
        self.dataUpdateAction.send(.prepend)
    }
}
