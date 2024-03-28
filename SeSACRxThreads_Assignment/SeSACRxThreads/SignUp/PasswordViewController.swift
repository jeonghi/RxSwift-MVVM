//
//  PasswordViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PasswordViewController: UIViewController {
  
  let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
  let validationLabel = UILabel()
  let nextButton = PointButton(title: "다음")
  
  let disposedBag = DisposeBag()
  
  private let minimalPasswordLength = 5
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = Color.white
    
    configureLayout()
    
    let passwordValid = passwordTextField.rx.text.orEmpty
      .map { $0.count >= self.minimalPasswordLength }
      
    passwordValid
      .map { $0 ? "확인 완료" : "Password has to be at least \(self.minimalPasswordLength) characters" }
      .bind(to: validationLabel.rx.text)
      .disposed(by: disposedBag)
    
    passwordValid
      .map { $0 ? 1.0 : 0.5 }
      .bind(to: nextButton.rx.alpha)
      .disposed(by: disposedBag)
    
    passwordValid
      .bind(to: nextButton.rx.isEnabled)
      .disposed(by: disposedBag)
    
    
    nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
  }
  
  @objc func nextButtonClicked() {
    navigationController?.pushViewController(PhoneViewController(), animated: true)
  }
  
  func configureLayout() {
    view.addSubview(passwordTextField)
    view.addSubview(nextButton)
    view.addSubview(validationLabel)
    
    passwordTextField.snp.makeConstraints { make in
      make.height.equalTo(50)
      make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
      make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
    }
    
    validationLabel.snp.makeConstraints { make in
      make.top.equalTo(passwordTextField.snp.bottom).offset(30)
      make.horizontalEdges.equalToSuperview().inset(20)
    }
    
    nextButton.snp.makeConstraints { make in
      make.height.equalTo(50)
      make.top.equalTo(validationLabel.snp.bottom).offset(30)
      make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
    }
  }
  
}
