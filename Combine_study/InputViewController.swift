//
//  InputViewController.swift
//  Combine_study
//
//  Created by 여원구 on 2023/04/16.
//

import Foundation
import UIKit
import SnapKit

class InputViewController: UIViewController {
    
    var delegate: UIViewController?
    
    private lazy var nameBox: UITextField = {
        let textField = UITextField()
        textField.placeholder = "name"
        textField.clearsOnBeginEditing = true
        textField.delegate = self
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 10
        textField.textContentType = .name
        return textField
    }()
    
    private lazy var ageBox: UITextField = {
        let textField = UITextField()
        textField.placeholder = "age"
        textField.clearsOnBeginEditing = true
        textField.delegate = self
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 10
        textField.textContentType = .telephoneNumber
        
        return textField
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let boxView = UIView()
        boxView.backgroundColor = .white
        boxView.layer.cornerRadius = 30
        view.addSubview(boxView)
        boxView.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(40)
            make.center.equalToSuperview()
            make.height.equalTo(200)
        }
        
        boxView.addSubview(nameBox)
        nameBox.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        boxView.addSubview(ageBox)
        ageBox.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(nameBox.snp.bottom).offset(20)
            make.height.equalTo(40)
        }
        
        let cancelBtn = makeButton(title: "취소", color: .red)
        boxView.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(ageBox.snp.bottom).offset(20)
            make.height.equalTo(40)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        let doneBtn = makeButton(title: "확인")
        boxView.addSubview(doneBtn)
        doneBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.top.height.equalTo(cancelBtn)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        
        nameBox.becomeFirstResponder()
    }
}

extension InputViewController {
    
    private func makeButton(title: String, color: UIColor = .systemBlue) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(color, for: .normal)
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return btn
    }
    
    @objc private func buttonAction(sender: UIButton) {
        if sender.titleLabel?.text == "확인" {
            (delegate as? MainViewController)?.setInputData(with: .append, name: nameBox.text, age: ageBox.text)
            dismiss(animated: true)
        }
        else {
            return
        }
    }
    
    func setInputData(with type: ViewModel.AddingType, name: String?, age: String?) {}
}

extension InputViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(#fileID, #function, #line, "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(#fileID, #function, #line, "")
        
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print(#fileID, #function, #line, "")
    }
}
