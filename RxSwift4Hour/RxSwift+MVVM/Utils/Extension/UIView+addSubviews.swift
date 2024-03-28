//
//  View+addSubviews.swift
//  RxSwift+MVVM
//
//  Created by 쩡화니 on 2/9/24.
//

import UIKit

extension UIView {
  func addSubviews(_ views: [UIView]) {
    views.forEach { self.addSubview($0) }
  }
}
