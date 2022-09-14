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

print("------elementAt------")

let tooUp = PublishSubject<String>()

tooUp
    .element(at: 2)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

tooUp.onNext("🔈") //index0
tooUp.onNext("🔈") //index1
tooUp.onNext("⭐️") //index2
tooUp.onNext("🔈") //index3
