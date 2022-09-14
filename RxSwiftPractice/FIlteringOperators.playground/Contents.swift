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

print("------filter------")
Observable.of(1,2,3,4,5,6,7,8)
    .filter { $0 % 2 == 0}
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
