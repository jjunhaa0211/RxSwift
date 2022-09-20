//
//  ViewCount.swift
//  RxSwiftPractice
//
//  Created by 박준하 on 2022/09/20.
//

import UIKit
import RxSwift

class CustomViewController: UIViewController {

  var disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    test()
  }
  
  deinit {
    print("deinit CustomViewController")
  }

  func test() {
      Observable<Int>.interval(.seconds(Int(1)), scheduler: MainScheduler.instance)
      .take(10)
      .subscribe(onNext: { value in
        print(value)
      }, onError: { error in
        print(error)
      }, onCompleted: {
        print("onCompleted")
      }, onDisposed: {
        print("onDisposed")
      })
      .disposed(by: disposeBag)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      UIApplication.shared.keyWindow?.rootViewController = nil
    }
  }
}
