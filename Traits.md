# Traits

---

`Single`, `Maybe`, `Completable`을 알아보도록 하자

`Single` = `succes` 이벤트 또는 `error` 이벤트를 한번만 방출하는 `Observable` 

// 이때 seucces 이벤트는 우리가 사용해왔던 onNext와 onComplete를 합친 것과 같습니다

사용 예)`Single`은 주로 사진을 다운로드하는데 사진을 저장했거나 사진이 저장이 안됐을 경우 등 됐다 안됐다라고 분별이 가능할 경우 사용된다(single은 succes와 error만을 가지고 있습니다)

`Maybe`는 `Single`과 비슷하지만 차이점은 성공적으로 되더라도 아무것도 방출하지 않는 `completed`을 포함한다 (때문에 가지고 있는 요소는 `completed`, `error`, `succes`를 가지고 있습니다

`Completable`은 두가지 요소를 가지고 있습니다 `completed`와 `error` 이제 `succes`가 없기 때문에 역시 출력하는 값이 없습니다 

그러면 `Completable`을 왜 사용할까? 지금까지는 동기를 접하지 못하다보니까 `Observable`의 `empty`나 `never` 처럼 아무 것도 방출하지 않는 것을 왜 사용할까? 하지만 동기식 연산에 성공 여부를 확인 할 때 `Completable`을 정말 유용하게 사용할 수 있습니다 

// 예) 내가 비동기로 어떤 처리값을 보냈다고 치면 비동기 결과가 잘됐으면 상관 없지만 성공하지 못했으면 error를 처리해주기 때문에 유용하게 사용할 수 있다

## Single

```swift
let disposeBag = DisposeBag()

enum TraitsError: Error {
    case single
    case maybe
    case completable
}

Single<String>.just("✅")
    .subscribe(
        onSuccess: {
            print($0)
        },
        onFailure: {
            print($0)
        },
        onDisposed: {
            print("disposed")
        }
    )
    .disposed(by: disposeBag)
```

지금까지 우리는 Observable을 공부하면 배운 코드는 `onNext`, `onError`, `onCompleted`, `onDisposed` 등이 있을 텐데 여기서 나오는 `onSuccess`는 `onNext`와 `onCompleted`를 합친 형태와 같습니다 그리고 `onFailure`는 `onError`과 같은 역활을 하고 `onDisposed`는 `dispose`와 같은 역활을 합니다

```swift
Observable<String>
    .create({ observer -> Disposable in
        observer.onError(TraitsError.single)
        return Disposables.create()
})
    .asSingle()
    .subscribe(
        onSuccess: {
        print($0)
    },
        onFailure: {
            print("error: \($0.localizedDescription)")
    },
        onDisposed: {
        print("disposed")
    })
```

위 코드 역시 위에 코드와 똑같은 결과가 나옵니다.

하지만 `craeate` 코드에서 `asSingle`을 사용하면 `Single`코드를 사용할 수 있다

보통의 `craete`라면 `onNext`, `onComplet` 등등이 나왔겠지만 현재의 경우에서는 `onSucess`, `onFailure`, `onDisposed`가 나온다는 사실을 알 수 있다, 이것이 `Single`로 변환하는 방법이다

```swift
struct SomeJSON: Decodable {
    let name: String
}

enum JSONError: Error {
    case decodingError
}

let json1 = """
    {"name": "park"}
    """

let json2 = """
    {"my_name": "junha"}
    """

func decode(json: String) -> Single<SomeJSON> {
    Single<SomeJSON>.create { observer -> Disposable in
        guard let data = json.data(using: .utf8),
              let json = try? JSONDecoder().decode(SomeJSON.self, from: data)
        else {
            observer(.failure(JSONError.decodingError))
            return Disposables.create()
        }
        
        observer(.success(json))
        return Disposables.create()
    }
}

decode(json: json1)
    .subscribe {
        switch $0 {
        case .success(let json):
            print(json.name)
            
        case .failure(let error):
            print(error)
        }
    }
    .disposed(by: disposeBag)

decode(json: json2)
    .subscribe {
        switch $0 {
        case .success(let json):
            print(json.name)
        case .failure(let error):
            print(error)
        }
    }
    .disposed(by: disposeBag)
```

코드의 json data가 `success`, `failure` 밖에 없는 이유는 `Single` 이니까 2가지의 경우 밖에 없다

위 코드를 보면 알 듯이 네트워크처럼 실패 또는 성공 밖에 없는 단순하게 하나의 이벤트만 주는 `Single`의 좋은 사용 예제라고 할 수 있다.

위 코드의 name처럼 기존에 정의한 코드를 작성한 json1은 error가 나지 않지만 json2의 값은 정의해 준 적 없는 data가 들어가 있기 때문에 failure을 출력한다

## Maybe

```swift
Maybe<String>.just("✅")
    .subscribe(onSuccess: {
        print($0)
    },
    onError: {
        print($0)
    },
    onCompleted: {
        print("completed")
    },
    onDisposed: {
        print("disposed")
    }
)
    .disposed(by: disposeBag)
```

그 전에 하던 `Single` 같은 경우에서 `succes`, `failure`, `disposed` 밖에 없었지만 `Maybe` 같은 경우에는 `onSucces`, `onError`, `onCompleted`, `onDisposed`가 있습니다

```swift
Observable<String>.create { observer -> Disposable in
    observer.onError(TraitsError.maybe)
    return Disposables.create()
}
.asMaybe()
.subscribe(
    onSuccess: {
        print("성공🙃 : \($0)")
    },
    onError: {
        print("에러🚫 : \($0)")
    },
    onCompleted: {
        print("completed")
    },
    onDisposed: {
        print("disposed")
    }
)
.disposed(by: disposeBag)
```

`asMaybe` 딱봐도 이제 뭔 것인지 알 것 같나요? 바로 기존의 `Observable`을 `maybe`로 바꾸어 주는 친구라는 것을 알겠죠? 때문에 `asMaybe`를 하는 순간 `string`인데 `maybe`를 가지는 `Observable`을 만들 수 있습니다

## Completable

```swift
Completable.create{ observer -> Disposable in
    observer(.error(TraitsError.completable))
    return Disposables.create()
}
.subscribe(
    onCompleted: {
        print("completed")
    },
    onError: {
        print("error: \($0)")
    },
    onDisposed: {
        print("disposed")
    }
)
.disposed(by: disposeBag)
```

위에서 말을 했드시 `completed`는 두가지 요소를 가지고 있는데 `completed`와 `Error` 두가지 밖에 없습니다

```swift
Completable.create{ observer -> Disposable in
    observer(.completed)
    return Disposables.create()
}
.subscribe {
    print($0)
}
.disposed(by: disposeBag)
```

위에서는 직접 `completed`라고 적었지만 자동으로 `subseribe`만 해줘도 `completed`가 뜹니다

그러면 의문점 그동안 `asSingle`, `asMaybe`처럼 변환할 수 있는게 있지 않으까? 놉! `Completable`은 그런거 없습니다.