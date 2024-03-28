//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PhoneViewController: UIViewController {
  
  private let minimalPhoneNumberLength = 10
  
  let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
  let nextButton = PointButton(title: "다음")
  
  var phoneNumberText = Observable<String>.just("010")
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = Color.white
    
    configureLayout()
    
    //    nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
    
    // 첫 화면 진입시 010 텍스트를 바로 띄워줌.
    phoneNumberText
      .bind(to: phoneTextField.rx.text)
      .disposed(by: disposeBag)
    
    let phoneTextFieldValid = phoneTextField.rx.text.orEmpty
      .map { $0.count >= self.minimalPhoneNumberLength && $0.isNumberByRegularExpression }
      .share(replay: 1) // rx는 default로 stateless라서 이거 안해주면, 한번 실행되고 뿅한다.
    
    phoneTextFieldValid
      .bind(to: nextButton.rx.isEnabled )
      .disposed(by: disposeBag)
    
    // 주말에 버튼 configuration으로 바꿔보기 📋
    phoneTextFieldValid
      .map { $0 ? 1.0 : 0.5 }
      .bind(to: nextButton.rx.alpha)
      .disposed(by: disposeBag)
    
  }
  
  @objc func nextButtonClicked() {
    navigationController?.pushViewController(NicknameViewController(), animated: true)
  }
  
  
  func configureLayout() {
    view.addSubview(phoneTextField)
    view.addSubview(nextButton)
    
    phoneTextField.snp.makeConstraints { make in
      make.height.equalTo(50)
      make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
      make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
    }
    
    nextButton.snp.makeConstraints { make in
      make.height.equalTo(50)
      make.top.equalTo(phoneTextField.snp.bottom).offset(30)
      make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
    }
  }
  
}

extension String {
  var isNumberByRegularExpression: Bool {
    range(
      of: "^[0-9]*$",
      options: .regularExpression
    ) != nil
  }
}
