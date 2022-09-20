# Subject

---

`Subject`란 = `Observable`이자 `Observer`인 것

- `PublishSubject` = 빈 상태로 시작하여서 새로운 값만을 `subscriber`에 방출한다

```
 subscriber는subscribe한 시점 이후에 발생되는 이벤트만 전달받는다.
```

- `BehaviorSubject` = 하나의 초기값을 가진 상태로 시작하여, 새로운 `subscriber`에게 초기값 또는 최신값을 방출한다

```
subscribe가 발생하면, 발생한 시점 이전에 발생한 이벤트 중 가장 최신의 이벤트를 전달받는다.
```

- `ReplaySubject` = 버퍼를 두고 초기화하며, 버퍼 사이즈 만큼의 값들을 유지하면서 새로운 `subscriber`에게 방출한다

```
BehaviorSubject와 유사하지만, BufferSize만큼의 최신 이벤트를 전달받는다.
```

## pubishSubject

```swift
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
```

정의를 설명하면서 보았듯이 `pubishSubject`의 특징은 빈 상태에서 `subscribe`한 시점 이후의 이벤트를 전송 받기 때문에 “여러분 안녕하세요”는 구독 정의 이벤트이기 떄문에 출력하지 않고요 구독자1이 구독받은 시점에서 2와 3이 출력될 것입니다 그리고 구독자1이 `dispose`로 이벤트를 끝냈기 때문에 다시 빈상태가 된 `pubishSubject`는 다시 구독자 2를 받습니다 그리고 “여보세요”를 출력한 후 “끝났어요”를 출력할까요? 아뇨 당연히 출력하지 않을 것입니다 위에서 이미 `completed`를 했기 때문에 5는 출력되지 않을 것입니다 그러면 6번은 출력 될까요? 아뇨 애초에 `onCompleted`를 해주었기 때문에 구독은 됐지만 6번의 `pubilshSubject`가 이미 끝났기 때문에 출력하지 않습니다

```swift
//답
//------PublishSubject------
//첫번째 구독자 : 2. 들리세요?
//첫번째 구독자 : 3. 안들리시나요?
//두번째 구독자 : 4. 여보세요
//세번째 구독자: completed
```

## behaviorSubject

```swift
enum SubjectError: Error {
****    case error1
}

let behaviorSubject = BehaviorSubject<String>(value: "0. 초기값")

behaviorSubject.onNext("1. 첫번째값")

behaviorSubject.subscribe {
    print("첫번째 구독:", $0.element ?? $0)
}
.disposed(by: disposeBag)

behaviorSubject.onError(SubjectError.error1)

behaviorSubject.subscribe {
    print("두번째구독:",$0.element ?? $0)
}
.disposed(by: disposeBag)

let value = try? behaviorSubject.value()
print(value)

//첫번째 구독: 1. 첫번째값
//두번째구독: 1. 첫번째값
//Optional("1. 첫번째값")
```

`PublishSubject`는 초기값이 필요 없었지만 `BehaviorSubject`는 반드시 초기값을 가진다.

1번은 구독이 시작된 이후에 구독을 실행하였는데도 구독이 잘 표현되는 것을 알 수 있습니다 왜냐하면 자신이 구독한 시점이 이벤트가 발생한 이후라하더라고 그 직전의 이벤트를 받을 수 있습니다.

그리고 `BehaviorSubject`의 특징 중 하나가 `value`값을 뽑아 낼 수 있다는 것이 장점입니다.

`value`의 값은 가장 최신의 값을 뽑아옵니다.

## ReplaySubject

```swift
let replaySubject = ReplaySubject<String>.create(bufferSize: 3)

replaySubject.onNext("1. 👺")
replaySubject.onNext("2. 🌹")
replaySubject.onNext("3. 🤓")

replaySubject.subscribe {
    print("첫번째구독:", $0.element ?? $0)
}
.disposed(by: disposeBag)

replaySubject.subscribe {
    print("두번째구독:", $0.element ?? $0)
}
.disposed(by: disposeBag)

replaySubject.onNext("4. 🥸")
replaySubject.onError(SubjectError.error1)
replaySubject.dispose()

replaySubject.subscribe {
    print("세번째구독:",$0.element ?? $0)
}
.disposed(by: disposeBag)
```

replaySubject를 작성할 때는 create를 해준 다음 bufferSize의 값을 통해서 몇개의 버터를 선언 할 수 있다.

```swift
//답
첫번째구독: 1. 👺
첫번째구독: 2. 🌹
첫번째구독: 3. 🤓
두번째구독: 1. 👺
두번째구독: 2. 🌹
두번째구독: 3. 🤓
첫번째구독: 4. 🥸
두번째구독: 4. 🥸
첫번째구독: error(error1)
두번째구독: error(error1)
세번째구독: error(Object `RxSwift.(unknown context at $10eb21ba0).ReplayMany<Swift.String>` was already disposed.)
```

첫번째 구독에서 1,2,3 코드를 전부 출력해주는 것을 알 수 있습니다 그 이유는 버퍼의 값을 3개를 정해주었기 때문입니다 그리고 두번째 구독 역기 1,2,3 이모티콘 전부 출력 해줍니다 하지만 첫번째의 마지막 선언을 해주었기 때문에 값이 4가 늦게 출력되고 두번째도 늦게 선언 되는 것을 알 수 있습니다 하지만 첫번째, 두번째는 우리가 정해준 error1이 출력되었지만 세번째 구독은 RxSwift의 error가 왜 뜰까요? 이유는 이미 disposed 되었는데 한번 되었기 때문입니다.

그러면 버퍼사이즈를 1또는 2로 줄이면 어떻게 될까요? 한번 해보시면 이해가 됩니다^^