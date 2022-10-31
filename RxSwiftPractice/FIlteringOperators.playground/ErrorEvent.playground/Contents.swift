import UIKit
import RxCocoa
import RxSwift

let disposeBag = DisposeBag()

//let observable = Observable<Int>
//    .create { observer -> Disposable in
//        observer.onNext(1)
//        observer.onNext(2)
//        observer.onNext(3)
//        observer.onError(NSError(domain: "", code: 100, userInfo: nil))
//        observer.onError(NSError(domain: "", code: 200, userInfo: nil))
//        return Disposables.create { }
//}
//observable
//    .catchErrorJustReturn(999)
//    .subscribe { print($0) }
//    .disposed(by: disposeBag)

//
//let observable = Observable<Int>
//    .create { observer -> Disposable in
//        observer.onNext(1)
//        observer.onNext(2)
//        observer.onNext(3)
//        observer.onError(NSError(domain: "", code: 100, userInfo: nil))
//        observer.onError(NSError(domain: "", code: 200, userInfo: nil))
//        return Disposables.create { }
//}
//
//observable
//    .retry(2)
//    .subscribe { print($0) }
//    .disposed(by: disposeBag)

let subject = PublishSubject<Int>()

subject.timeout(.seconds(3), other: Observable.just(100), scheduler: MainScheduler.instance)
    .subscribe{print($0)}
    .disposed(by: disposeBag)

Observable<Int>.timer(.seconds(2), period: .seconds(2), scheduler: MainScheduler.instance)
    .take(5)
    .subscribe { subject.onNext($0) }
    .disposed(by: disposeBag)
