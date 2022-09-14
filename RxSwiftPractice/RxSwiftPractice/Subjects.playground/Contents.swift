import RxSwift

let disposeBag = DisposeBag()

print("------PublishSubject------")

let pubilshSubject = PublishSubject<String>()

pubilshSubject.onNext("1. 여러분 안녕하세요?")

let 구독자1 = pubilshSubject
    .subscribe(onNext: {
        print("첫번째 구독자 : \($0)")
    })

pubilshSubject.onNext("2. 들리세요?")
pubilshSubject.on(.next("3. 안들리시나요?"))

구독자1.dispose()

let 구독자2 = pubilshSubject
    .subscribe(onNext: {
        print("두번째 구독자 : \($0)")
    })

pubilshSubject.onNext("4. 여보세요")
pubilshSubject.onCompleted()

pubilshSubject.onNext("5. 끝났어요")

구독자2.dispose()

pubilshSubject
    .subscribe {
        print("세번째 구독자:", $0.element ?? $0)
    }
    .disposed(by: disposeBag)

pubilshSubject.onNext("6. 찍을까요?")
