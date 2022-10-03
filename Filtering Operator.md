# Filtering Operator

---

`Filering Operator`란 `Observable`이 발행한 데이터들을 `Filtering`하는 `Operator`들입니다.

## ignoreElements

```swift
import RxSwift

let disposeBag = DisposeBag()
print("------ignoreElements------")
let sleepMode = PublishSubject<String>()

sleepMode
    .ignoreElements()
    .subscribe {
        print($0)
    }
    .disposed(by: disposeBag)

sleepMode.onNext("🔈")
sleepMode.onNext("🔈")
sleepMode.onNext("🔈")

sleepMode.onCompleted()
```

실행을 시키면 아무런 이벤트도 발생하지 않습니다 왜냐하면 `ignoreElements`는 `Next` 이벤트를 무시하는 친구입니다 `completed` 또는 `error` 같은 정지 이벤트는 허용하지만 `onNext` 이벤트는 전부 무시합니다 `completed`를 실행하면 `completed` 밖에 나오지 않는 것을 확인할 수 있습니다

## elementAt

```swift
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
```

기본적으로 `element`를 주석처리하고 `onNext`를 출력하면 `onNext`들이 전부 출력될 것 입니다 하지만 `element`에서 2라고 써주시면 원하는 `index`에 있는 `onNext`를 출력할 수 있습니다

## fileter

```swift
Observable.of(1,2,3,4,5,6,7,8)
    .filter { $0 % 2 == 0}
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
```

쉽게 생각하면 RxSwift에서의 `if`문이라고 생각 하지면 쉬울 것 같습니다(위 코드의 경우 짝수만 방출 하는 것입니다)

## skip

```swift
Observable.of("🥸","😀","😁","😇","😊","🥺","😃")
    .skip(5)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
```

`skip`은 말그대로 자기가 정한 값만큼은 `skip`하고 나머지를 출력한다는 것 입니다 (위 코드에서는 🥺  😃 출력될 것입니다)

## skipWhile

```swift
Observable.of("🥇","🥈","🥉","🤓","😎")
    .take(while: {
        $0 != "🥉"
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
```

`skipWhile`은 어떤 요소를 `skip` 하지 않을 때까지 방출하지 않는다 떄문에 `fileter`와 반대이며 `false`값이 방출되면 즉시 방출한다

## skipUntil

```swift
//기존 observable이 실행되고 그때부터 실행
let p = PublishSubject<String>()
let d = PublishSubject<String>()

p
    .skip(until: d)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

p.onNext("🥲")
p.onNext("😜")

d.onNext("땡!")
p.onNext("😢")
```

기존에 위에서 방출한 `onNext`가 🥲, 😜도 있지만 이들은 방출되지 않고 “땡!” 이라는 말이 나오고 나서부터인 😢  나오는 것을 알 수 있다 😢 `skipUntil`은 현재 `Observable`이 `onNext`를 방출하기 전까지는 아무런 이벤트도 방출하지 않지만 필터링의 기준이 되는 `Observable`이 방출되면 이벤트를 방출합니다

## take

```swift

Observable.of("🥇","🥈","🥉","🤓","😎")
    .take(3)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
```

`take`는 `skip`의 반대 개념이다.  `skip`은 원하는 값을 입력하면 그 값까지 뛰고 출력을 하였지만 `take`는 자신이 원한 값의 `index`번호까지만 출력을 한다

## takeWhile

```swift
Observable.of("🥇","🥈","🥉","🤓","😎")
    .take(while: {
        $0 != "🥉"
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
```

`takeWhile`은 값이 `true`일 때 까지 출력하기 때문에 조건이 맞지 않으면 즉시 출력을 종료한다

## enumerated

```swift
Observable.of("🥇","🥈","🥉","🤓","😎")
    .enumerated()
    .takeWhile {
        $0.index < 3
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag )
```

`enumerated`는 기존에 `take`의 출력 방식이 위의 이모지만 출력하였지만 `enumerated`를 사용하면 index번호도 같이 출력해줍니다 때문에 `enumerated`는 주로 방출된 `index`를 알고 싶을 때 사용합니다 위에 `index` < 3의 의미는 `index`가 3보다 작을 때까지 출력이라는 뜻 입니다

## takeUntil

```swift
let handsUp = PublishSubject<String>()
let handsDown = PublishSubject<String>()

handsUp
    .take(until: handsDown)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

handsUp.onNext("🙋‍♀️")
handsUp.onNext("🙋")

handsDown.onNext("손 내려!")
handsUp.onNext("🫡")
```

`takeUntil`에서는 `sikpUntil`과 정반대 개념으로 `takeUntil`에서는 `until`에서의 `handsDown`이 나오면 그때부터 `completed` 가 되기 떄문에 `handsDown` 나온 후 부터의 값은 출력되지 않습니다.  쉽게 생각하면 위에서 `until`의 값이 구독되기 전까지에 값만 출력하고 구독되면 더 이상 출력하지 않는다고 생각하면 편할 것 같습니다

## distincrUntilChanged

```swift
Observable.of("저는","저는","박준하","박준하","박준하","박준하","박준하","입니다","입니다",
							"입니다","입니다","저는","박준하","일까요?","일까요?")
    .distinctUntilChanged()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
```

쉽게 생각하면 `distincrUntilChanged`는 SQL에서의 `distinct`?라고 생각하면 쉬울 것 같다

무슨 뜻이냐면 중복을 제거하는 것이다 때문에 위의 출력값을 보면 “저는 박준하 입니다 저는 박준하 일까요?” 가 출력됩니다 그러면 여기서 의문점 `distinct`라고 했는데 왜 값이 중복 되는데 “저요”, “박준하”는 왜 “일까요?” 에서 출력이 될까요? 이유는 `distincrUntilChanged`는 값이 연속적이여야 하기 때문입니다 값이 띄워져 있으면 서로 다를 값으로 생각하고 출력합니다