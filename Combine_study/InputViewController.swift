//
//  InputViewController.swift
//  Combine_study
//
//  Created by 여원구 on 2023/04/16.
//

import Foundation
import UIKit
import SnapKit
import Combine

class InputViewController: UIViewController {
    
    var delegate: UIViewController?
    var type: TableViewModel.AddingType = .prepend
    
    // 이름 박스
    private lazy var nameBox: UITextField = {
        let textField = UITextField()
        textField.placeholder = "name"
        textField.clearsOnBeginEditing = true
        textField.delegate = self
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 10
        textField.textContentType = .name
        textField.keyboardType = .namePhonePad
        return textField
    }()
    
    // 나이 박스
    private lazy var ageBox: UITextField = {
        let textField = UITextField()
        textField.placeholder = "age"
        textField.clearsOnBeginEditing = true
        textField.delegate = self
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 10
        textField.keyboardType = .numberPad
        
        return textField
    }()
    
    // 확인버튼
    private lazy var doneBtn: UIButton = {
        let btn = makeButton(title: "확인")
        btn.isEnabled = false
        return btn
    }()
    
    // input view model
    var inputViewModel: InputViewModel = InputViewModel()
    var cancelable = Set<AnyCancellable>()
    
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
        
        boxView.addSubview(doneBtn)
        doneBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.top.height.equalTo(cancelBtn)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        nameBox.becomeFirstResponder()
        
        setBinding()
    }
}

extension InputViewController {
    
    private func setBinding() {
        inputViewModel.$enableBtn.sink { [self] isEnable in
            doneBtn.isEnabled = isEnable
        }.store(in: &cancelable)
    }
    
    private func makeButton(title: String, color: UIColor = .systemBlue) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(color, for: .normal)
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        btn.setTitleColor(.lightGray, for: .disabled)
        return btn
    }
    
    @objc private func buttonAction(sender: UIButton) {
        if sender.titleLabel?.text == "확인" {
            (delegate as? MainViewController)?.setInputData(with: type, name: nameBox.text, age: ageBox.text)
            dismiss(animated: true)
        }
        else if sender.titleLabel?.text == "취소" {
            dismiss(animated: true)
        }
        else {
            return
        }
    }
}

extension InputViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(#fileID, #function, #line, "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(#fileID, #function, #line, "")
        
        if nameBox.text?.isEmpty == false && ageBox.text?.isEmpty == false {
            (delegate as? MainViewController)?.setInputData(with: type, name: nameBox.text, age: ageBox.text)
            dismiss(animated: true)
            return true
        }
        
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 나이 필드에는 숫자 값만
        if textField == ageBox {
            let allowedCharacters: CharacterSet = .decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print(#fileID, #function, #line, "")
        
        // 이름, 나이 필드에 값이 둘다 들어간 경우에만 '확인'버튼 활성화
        if nameBox.text?.isEmpty == false && ageBox.text?.isEmpty == false {
            inputViewModel.enableBtn = true
        }else {
            inputViewModel.enableBtn = false
        }
    }
}
