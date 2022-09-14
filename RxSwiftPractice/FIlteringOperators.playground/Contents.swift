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

print("------skip------")
Observable.of("🥸","😀","😁","😇","😊","🥺")
    .skip(5)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------skipWhile------")
Observable.of("🥸","😀","😁","😇","😊","🥺","🤬","🐶","🥰")
    .skip(while: {
        $0 != "🐶"
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------skipUntil------")
//기존 observable이 실행되고 그때부터 실행
let 손님 = PublishSubject<String>()
let 문여는시간 = PublishSubject<String>()

손님
    .skip(until: 문여는시간)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

손님.onNext("🥲")
손님.onNext("😜")

문여는시간.onNext("땡!")
손님.onNext("😢")
