//
//  HiRabbit.swift
//  RxSwiftPractice
//
//  Created by 박준하 on 2022/09/20.
//

import UIKit
import RxSwift
import RxCocoa

class HiRabbit {
    struct Rabbit {
        let appearRabbit = "토끼님 등장!!🐰"
    }
    var disposeBag = DisposeBag()
    let timer = Observable<Int>.interval(.seconds(Int(3.0)), scheduler: MainScheduler.instance)
    
    init() {
        timer.map { _ in
            Rabbit()
        }.subscribe(onNext: { rabbit in
            print(rabbit.appearRabbit)
        }).disposed(by: disposeBag)
    }
}
