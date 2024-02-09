//
//  ViewController.swift
//  RxSwift+MVVM
//
//  Created by 쩡화니 on 2/9/24.
//

import UIKit
import Then
import SnapKit

let MEMBER_LIST_URL = "https://my.api.mockaroo.com/members_with_avatar.json?key=44ce18f0"

class 나중에생기는데이터<T> {
  private let task: (@escaping (T) -> Void) -> Void
  
  init(task: @escaping (@escaping (T) -> Void) -> Void) {
    self.task = task
  }
  
  func 나중에오면(_ f: @escaping (T) -> Void) {
    task(f)
  }
}

class ViewController: UIViewController {
  
  // MARK: IBOutlet
  var timerLabel: UILabel = .init().then {
    $0.textColor = .black
    $0.font = .boldSystemFont(ofSize: 20)
  }
  
  lazy var loadButton: UIButton = .init().then {
    $0.setTitle("로드하기", for: .normal)
    $0.addTarget(self, action: #selector(self.tappedLoadButton), for: .touchUpInside)
    $0.backgroundColor = .black
  }
  var activityIndicator: UIActivityIndicatorView = .init()
  var editView: UITextView = .init().then {
    $0.backgroundColor = .lightGray.withAlphaComponent(0.5)
  }
  
  // MARK: Life cycle
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configView()
    configHierarchy()
    configLayout()
    startTimer()
  }
  
  // MARK: IBAction
  private func setVisibleWithAnimation(_ uiView: UIView?, _ isHidden: Bool){
    guard let uiView else { return }
    UIView.animate(withDuration: 0.3) { [weak uiView] in
      uiView?.isHidden = !isHidden
    } completion: { [weak self] _ in
      self?.view.layoutIfNeeded()
    }
  }
  
  func downloadJSON(_ url: String) -> 나중에생기는데이터<String?> {
    return 나중에생기는데이터() { f in
      DispatchQueue.global().async {
        let url = URL(string: url)!
        let data = try! Data(contentsOf: url)
        let json = String(data: data, encoding: .utf8)
        DispatchQueue.main.async {
          f(json)
        }
      }
    }
  }
  
  // MARK: SYNC
  @objc
  func tappedLoadButton(){
    editView.text = ""
    self.setVisibleWithAnimation(self.activityIndicator, true)
    
    downloadJSON(MEMBER_LIST_URL)
      .나중에오면 { json in
        self.editView.text = json
        self.setVisibleWithAnimation(self.activityIndicator, false)
      }
    
//    let json: 나중에생기는데이터<String?> = downloadJSON(MEMBER_LIST_URL)
//    
//    json.나중에오면 { json in
//      self.editView.text = json
//      self.setVisibleWithAnimation(self.activityIndicator, false)
//    }
  }
}

extension ViewController {
  
  func configView() {
    view.backgroundColor = .white
  }
  
  func configHierarchy(){
    view.addSubviews([timerLabel, loadButton, activityIndicator, editView])
  }
  
  func configLayout(){
    timerLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    loadButton.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(60)
      $0.top.equalTo(timerLabel.snp.bottom).offset(20)
    }
    
    editView.snp.makeConstraints {
      $0.top.equalTo(loadButton.snp.bottom).offset(20)
      $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
  }
  
  func startTimer() {
    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
      self?.timerLabel.text = "\(Date().timeIntervalSince1970)"
    }
  }
}

@available(iOS 17.0, *)
#Preview {
  ViewController()
}
