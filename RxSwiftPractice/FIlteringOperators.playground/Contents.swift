import RxSwift

let disposeBag = DisposeBag()
print("------ignoreElements------")
let 취침모드 = PublishSubject<String>()

취침모드
    .ignoreElements()
    .subscribe { _ in
        print("⭐️")
    }
    .disposed(by: disposeBag)

취침모드.onNext("🔈")
취침모드.onNext("🔈")
취침모드.onNext("🔈")

취침모드.onCompleted()
