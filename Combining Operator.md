# Combining Operator

---

 Combining Operator는 초기값을 받는지 여부를 알 수 있습니다 ex) 현재위치 ,네트워크 등등 초기값이 필요한 상태 때 사용하는 것

## startWith

```swift
let face = Observable<String>.of("😠", "🤯", "😆")

face
		.startWith("😎 first face")
		.subscribe(onNext: {
				print($0)
		})
		.disposed(by: disposBag)
```

`startWith`는 초반의 초기값을 적어주는 명령어 입니다 만약 위코드가 실행되면 "😎 first face" 제일 먼저 출력되고 "😠", "🤯", "😆" 이것들이 순서대로 나옵니다 그런데 주의할 점은 위에 `Observable`은 전부 String인 것을 알 수 있습니다 때문에 타입을 전부 맞추어 주어야합니다 그래서 만약 제가 “first face” 아닌 정수를 사용하면 오류가 납니다

하지만 궁금해서 코드를 추가 해보겠다

```swift
let face = Observable<String>.of("😠", "🤯", "😆")

face
		.enumerated()
		.map { index, element in
				return element + "얼굴" + "\(index)"
		.startWith("😎 first face")
		.subscribe(onNext: {
				print($0)
		})
		.disposed(by: disposBag)

//출력
//😎 first face
//😠얼굴0
//🤯얼굴1
//😆얼굴2
```

위 코드에서 알 수 있는 것이 무엇이 있을까요? 

- `startWith`는 꼭 위에 써주지 않아도 된다
- 처음 `startWith`의 값은 `index`값에 포함되지 않는다

를 알게 되었다

## concat

```swift
let happyFace = Observable<String>.of("😀", "🤪", "🤤")
let badFace = Observable<String>.of("😨 헉")
let face = Observable
					.concat([badFace, happyFace])

face
		.subscrib(onNext: {
				print($0)
		})
		.disposed(by: disposeBag)
```

`concat`은 우선순위 정해주기? 라고 알고 있으면 될 것 같다 먼저 입력된 배열을 순서대로 진행이 되기 때문이다 지금 코드의 경우에는 badFace가 먼저 출력되고 happuFace가 face에 담겼지만 0번째 배열이 badFace이기 때문에 badFace 출력후 happyFace가 출력될 것이다 물론 코드를 더 줄여서 똑같은 결과를 만들 수 있다

```swift
let happyFace = Observable<String>.of("😀", "🤪", "🤤")
let badFace = Observable<String>.of("😨 헉")

badFace
			.concat(happyFace)
			.subscribe(onNext: {
						print($0)
		})
		.disposed(by: disposed)
```

이런 식으로 적으면 badFace를 출력한 후에 `concat`에 들어있는 happyFace를 출력할 것이다

## concatMap

```swift
let face: [String]: Observable<String> = [
			"badFace": Observable.of("🥵","🤢","🤮"),
			"happyFace": Observable.of("😀", "🤪", "🤤")
]

Observable.of("badFace", "happyFace")
				.concatMap { Face in
							face[Face] ?? .empty()
				}
				.subscribe(onNext: {
						print($0)
				})
				.didsposed(by: disposeBag)

//출력
//🥵
//🤢
//🤮
//😀
//🤪
//🤤
```

`concatMap`은 각각의 시퀀스가 다음 시퀀스 구독되기 전에 합쳐지는 것을 보증합니다 위에서는 badFace와 happyFace 얼굴을 나타낼 시퀀스를 준비하고 특정 얼굴을 출력하고 나면 다음 출력하는 것을 보여주는 것이 `concatMap`입니다

## merge

```swift
let snack = Observable.from(["썬칩", "새우깡", "양파링", "뺴뺴로", "포카칩" ])
let fruit = Observable.from(["사과", "오렌지", "배", "포도", "귤" ])

Observable.of(snack, fruit)
				.merge()
				.subscribe(onNext: {
						print($0)
				})
				.disposed(by: disposBag)
```

`merge`는 병합이다 쉽게 합치는 것이라고 생각하자 하지만 불규칙적이고 순서를 보장하지 않는다는 단점? 이 있다 그러면 `merge`는 언제 끝날까? `merge`는 모든 값을 출력한 후에 출력한다 때문에 snack 또는 fruit 중에 `error`가 발견되면 즉시 에러가 발생한다

```swift
Observable.of(snack, fruit)
				.merge(maxConcurrent: 1)
				.subscribe(onNext: {
						print($0)
				})
				.disposed(by: disposeBag)
```

자 요번에는 또 뭘까요 `merge`에 `maxConcurrent`를 해주면는 지금 같은 경우에는 1개이기 때문에 snack이 끝내기 전까지 다른 값을 내보내지 않습니다 그니까 첫번째 시퀀스가 끝나자마자 두번째 시퀀스를 구독합니다

## combineLatest

```swift
let fristName = PublishSubject<String>()
let lastName = PublishSubject<String>()

let name = Observable
			.combineLatest(fristName, lastName) { fn, ln in
							fn + ln
						}
name
		.subscribe(onNext: {
				print($0)
		})
		.disposed(by: disposeBag)

fristName.onNext("박")
lastName.onNext("준하")
lastName.onNext("똑똑")
lastName.onNext("멍청")
fristName.onNext("이")
fristName.onNext("김")

//출력
//
//박준하
//박똑똑
//박멍청
//이멍청
//김멍청

```

`combineLatest`는 안에 들어와야하는 클로져가 있는데 저기 클로저에 값들이 들어오면 출력하는 형식이다 때문에 처음 들어가 fristName안에 있는 “박” 이라는 값은 다른 값이 들어오기 전까지는 계속 남아 있고 lastName이 들어오면 fristName과 lastName이 결합되어서 출력이 된다 하지만 위 코드처럼 lastName만을 `onNext`하게되면 그전에 있는 fristName을 가져와서 사용한다 또는 fristName만을 출력하면 그전에 가지고 있었던 lastName을 출력하게된다

```swift
let dateFormat = Observable<DateFormatter.Style>.of(.short, .long)
let nowDate = Observable<Date>.of(Date())

let nowDatePost = Observable
				.combineLatest {
							dateFormat,
							nowDate
							resultSelector: { formatter, date -> String in
									let dateFormatter = DateFormatter()
									dateFormatter.dateStyle = formatte
									return dateFormatter.string(from: date)
					     }
						}
nowDatePost
				.subcribe(onNext: {
							print($0)
				})
				.disposd(by: disposeBag)
```

`combineLatest`를 응용하여서 만든 날짜 출력 코드입니다 해석하면 `combineLatest`를 앞으로 응용할 수 있으니 해석해보는 것을 추천합니다

여기서 팁은 `combineLatest`는 한가지, 두가지만 받아오는 것이 아니라 여러가지 데이터를 받아올 수 있습니다(최대 8개)

```swift
let lastName = PublishSubject<String>()
let firstName = PublishSubject<String>()

let fullName = Observable
				.combineLatest([firstName, lastName[) { name in
							name.joined(separator: " ")
				}
fullName
			.subscribe(onNext: {
						print($0)
				})
				.disposed(by: disposeBag)
lastName.onNext("김")
firstName.onNext("짱구")
firstName.onNext("진구")
firstName.onNext("비실")

//출력
//
//짱구 김
//진구 김
//비실 김

```

위처럼 `combineLatest`를 `collection`으로도 받을 수 있는데요 전코드 처럼 `resultSelector`를 사용하는 방법도 있지만 이말고도 `collection`을 사용하는 방법에서는 말 그대로 배열을 받을 수 있도록 해줍니다 그리고 밑에 있는 `joind(separator: “ “)`는 별 것은 아니고 그냥 firstName과 lastName을 더할 때 `separator`안에 값을 정해주면 그 값이 firstName뒤에 lastName 앞에 들어갑니다

## zip

```swift
enum winAndLose {
		case win
		case lose
}

let games = Observable<winAndLose>.of(.win, .win, .lose, .win, .lose)
let players = Observable<String>.of("한국", "미국", "일본", "프랑스", "독일", "중국")

let gameResult = Observable
			.zip(games,players){ result, player in
					return player + "선수" + "\(result)"
			}

gameResult
			.subscribe(onNext: {
						print($0)
			})
			.disposed(by: disposedBag)
```

`zip`의 특징은 두개의 시퀀스를 합치지만 둘중 하나라도 끝나면 종료해버리는 특징이 있습니다 때문애 games는 5개지만 players는 6개이기 때문에 “중국”은 출력되지 않습니다 zip 역시 `combineLatest`처럼 최대로 조합할 수 있는 시퀀스는 8개입니다

## withLatestFrom

```swift
let start = PublishSubject<Void>()
let runner = PublishSubject<String>()

runner
		.withLatestFrom(runner)
		.subscribe(onNext: {
				print($0)
		})
		.disposed(by: disposeBag)

runner.onNext("run")
runner.onNext("run run")
runner.onNext("run run run")

start.onNext(Void())
```

`withLatestFrom`은 가장 최신의 값을 배출해줍니다 여기서 `withLatestFrom` 안에 runner를 넣어 주었기 때문에 `noNext`를 아무리 많이 해도 출력 결과는 가장 최근의 값인 "run run run"만 배출해 줄 것 입니다

## sample

```swift
let start = PublishSubject<Void>()
let player = PublishSubject<Void>()

player
			.sample(start)
			.subscribe(onNext: {
					print($0)
			})
			.disposed(by: disposBag)

player.onNext("1")
player.onNext("1 2")
player.onNext("1 2 3")

start.onNext(Void())
start.onNext(Void())
start.onNext(Void())
```

`sample`은 `withLatesFrom`과 매우 유사하고 출력 결과 역시 가장최근의 값을 한다는 것에서 같지만 하나 다를 점은 `sample`은 아무리 출력을 할려고 해도 아무리 `onNext`를 많이 적어도 단 한번만 출력하고 더이상 출력하지 않습니다

> 여기서 나는 `withlatesFrom`을 `sample`처럼 사용하고 싶다 하면 `distinctUntilChanged`를 사용하면 된다
> 

## amb

```swift
let bus1 = PubilshSubject<String>()
let bus2 = PublishSubject<String>()

let station = bus1.amb(bus2)

station
		.subscribe(onNext: {
				print($0)
		})
		.disposed(by: disposeBag)

bus2.onNext("버스2 승객1")
bus1.onNext("버스1 승객1")
bus2.onNext("버스2 승객2")
bus1.onNext("버스1 승객2")
bus2.onNext("버스2 승객3")
```

`amb`는 쉽게 말해서 먼저 구독되는 것을 출력하고 그다음 구독되는 것을 출력하지 않습니다 지금 상황에서는 bus2가 먼저 구독되었죠? 그럼면 bus2의 `onNext`들은 전부 출력되지만 bus1의 결과들은 출력되지 않습니다