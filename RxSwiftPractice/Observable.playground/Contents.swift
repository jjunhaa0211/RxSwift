import UIKit
import RxSwift
import Foundation

print("-----Just-----")
Observable<Int>.just(1)
    .subscribe(onNext: {
        print($0)
    })

//하나이상을 넣을 수 있다
print("-----Of1-----")
Observable<Int>.of(1, 2, 3, 4, 5)
    .subscribe(onNext: {
        print($0)
    })

print("-----Of2-----")
Observable.of([1, 2, 3, 4, 5])
    .subscribe(onNext: {
        print($0)
    })
Observable.just([1, 2, 3, 4, 5])

print("-----From-----")
//from은 arr만 받을 수 있다
Observable.from([1, 2, 3, 4, 5])
    .subscribe(onNext: {
    print($0)
})

print("-----subscribe1-----")
Observable.of(1, 2, 3)
    .subscribe {
        print($0)
    }

print("-----subscribe2-----")
Observable.of(1,2,3)
    .subscribe {
        if let element = $0.element {
            print(element)
        }
    }
print("-----subscribe3-----")
Observable.of(1,2,3)
    .subscribe(onNext: {
        print($0)
    })
print("-----empty-----")
//즉시 종료하고 싶을떄 또는 의도적으로 빈 값을 내보내기 위해서 사용
Observable<Void>.empty()
    .subscribe {
        print($0)
    }

print("-----never-----")
//empty와 반대되는 개념
Observable.never()
    .debug("never")
    .subscribe(
        onNext: {
            print($0)
        }, onCompleted: {
            print("Comleted")
        })

print("-----range-----")
Observable.range(start: 1, count: 9)
    .subscribe(onNext: {
        print("2 * \($0) = \(2*$0)")
    })

print("-----dispose-----")
//메모리 누수를 막음
Observable.of(1, 2, 3)
    .subscribe(onNext: {
        print($0)
    })
    .dispose()

print("-----disposeBag-----")
let disposeBag = DisposeBag()

Observable.of(1,2,3)
    .subscribe {
        print($0)
    }
    .disposed(by: disposeBag)

print("-----create1-----")
Observable.create { observar -> Disposable in
    observar.onNext(1)
    //observar.on(.next())
    observar.onCompleted()
    //observar.on(.completed)
    
    //onNext2가 방출되지 않은 이유는 위에서 onCompleted를 해줘서 그렇다
    observar.onNext(2)
    
    return Disposables.create()
}
.subscribe {
    print($0)
}
.disposed(by: disposeBag)

print("-----create2-----")
enum MyError: Error {
    case anError
}

Observable<Int>.create { observer -> Disposable in
    observer.onNext(1)
    //error은 자기 지점에서 멈춘다
//    observer.onError(MyError.anError)
//    observer.onCompleted()
    observer.onNext(2)
    return Disposables.create()
}
.subscribe(
    onNext: {
        print($0)
    },
    onError: {
        print($0.localizedDescription)
    },
    onCompleted: {
        print("Completed")
    },
    onDisposed: {
        print("Disposed")
    }
)
.disposed(by: disposeBag)

print("-----deffered1-----")
Observable.deferred {
    Observable.of(1,2,3)
}
.subscribe {
    print($0)
}
.disposed(by: disposeBag)

print("-----deffered2-----")

var 뒤집기: Bool = false
let fatory: Observable<String> = Observable.deferred {
    뒤집기 = !뒤집기
    
    if 뒤집기 {
        return Observable.of("👊")
    } else {
        return Observable.of("✋")
    }
}

for _ in 0...3 {
    fatory.subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
}
