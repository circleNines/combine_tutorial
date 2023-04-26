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
    var tableViewModel: TableViewModel = TableViewModel()
    var cancelable = Set<AnyCancellable>() // disposebag
    
    lazy var myTableView: ExTableView = {
        let view = ExTableView(frame: .zero, style: .plain)
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    private lazy var prependBtn: UIBarButtonItem = {
        let btn = UIButton(type: .custom)
        btn.accessibilityIdentifier = "prepend"
        btn.setTitle("prepend", for: .normal)
        btn.setTitleColor(.green, for: .normal)
        btn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return UIBarButtonItem(customView: btn)
    }()
    
    private lazy var appendBtn: UIBarButtonItem = {
        let btn = UIButton(type: .custom)
        btn.accessibilityIdentifier = "append"
        btn.setTitle("append", for: .normal)
        btn.setTitleColor(.orange, for: .normal)
        btn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return UIBarButtonItem(customView: btn)
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = .white
        title = "Combine Table"
        
        navigationItem.leftBarButtonItem = prependBtn
        navigationItem.rightBarButtonItem = appendBtn
    }
    
    @objc private func buttonAction(sender: UIBarButtonItem) {
        
        let type: TableViewModel.AddingType = sender.accessibilityIdentifier == "prepend" ? .prepend : .append
        
        let ipViewController = InputViewController()
        ipViewController.delegate = self
        ipViewController.type = type
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
        
        tableViewModel.$list.sink { models in
            self.list = models
        }.store(in: &cancelable)
        
        tableViewModel.dataUpdateAction.sink { [self] type in
            // type에 따른 tableView 위치 조정
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
    
    func setInputData(with type: TableViewModel.AddingType, name: String?, age: String?) {
        
        guard name != nil else { return }
        guard age != nil else { return }
        
        let item = MyModel(title: name, detail: age)
        
        switch type {
        case .append:
            tableViewModel.appendData(item: item)
            
        case .prepend:
            tableViewModel.prependData(item: item)
        }
    }
}

extension MainViewController: UITableViewDelegate {}

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
        reloadData()
        layoutIfNeeded()
        
        setContentOffset(.zero, animated: true)
    }
    
    fileprivate func appendingDataOffset() {
        reloadData()
        layoutIfNeeded()
        
        setContentOffset(CGPoint(x: 0, y: contentSize.height - frame.size.height), animated: true)
    }
}
