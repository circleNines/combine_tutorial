//
//  MainViewController.swift
//  Combine_study
//
//  Created by 여원구 on 2023/03/28.
//

import Foundation
import UIKit
import SnapKit
import Combine

class MainViewController: UIViewController {
    
    var list: [MyModel] = []
    var viewModel: ViewModel = ViewModel()
    var cancelable = Set<AnyCancellable>()
    
    lazy var myTableView: ExTableView = {
        let view = ExTableView(frame: .zero, style: .plain)
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = .white
        title = "Combine Table"
        
        let barButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(buttonAction))
        navigationItem.rightBarButtonItem = barButton

    }
    
    @objc private func buttonAction(sender: UIButton) {
        //viewModel.list.insert(MyModel(title: "새로운 타이틀"), at: 0)
        //viewModel.prependData()
        let ipViewController = InputViewController()
        ipViewController.delegate = self
        ipViewController.modalPresentationStyle = .popover
        ipViewController.modalTransitionStyle = .crossDissolve
        present(ipViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(myTableView)
        myTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        setBinding()
    }
}

extension MainViewController {
    
    private func setBinding() {
        viewModel.$list.sink { models in
            self.list = models
            self.myTableView.reloadData()
        }.store(in: &cancelable)
        
        viewModel.dataUpdateAction.sink { [self] type in
            print("addingType === \(type)")
            switch type {
            case .append:
                myTableView.appendingDataOffset()
                break
            case .prepend:
                myTableView.prependingDataOffset()
                break
            }
        }.store(in: &cancelable)
    }
    
    func setInputData(with type: ViewModel.AddingType, name: String?, age: String?) {
        
         guard name != nil else { return }
         guard age != nil else { return }
         
         var listed = viewModel.list
         
         switch type {
         case .append:
             print("append name: \(name), age: \(age)")
             listed.insert(MyModel(title: name, detail: age), at: 0)
             viewModel.list = listed
             
         case .prepend:
             print("prepend name: \(name), age: \(age)")
             listed.append(MyModel(title: name, detail: age))
             viewModel.list = listed
         }
     }
}

extension MainViewController: UITableViewDelegate {  }

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        }

        cell?.textLabel?.text = list[indexPath.row].title
        cell?.detailTextLabel?.text = list[indexPath.row].detail
        
        return cell!
    }
}

class ExTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        bounces = false
        automaticallyAdjustsScrollIndicatorInsets = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ExTableView {
    fileprivate func prependingDataOffset() {
        setContentOffset(.zero, animated: true)
    }
    
    fileprivate func appendingDataOffset() {
        setContentOffset(CGPoint(x: 0, y: contentSize.height), animated: true)
    }
}
