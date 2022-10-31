# RxSwift Error처리

---

RxSwift의 error처리 방법은 3가지로 나누어 집니다

- catch = 특정값을 복구
- retry = 재시도하기
- materialize / dematerialize : Sequence 를 제어해서 처리
- timeout

# Catch

swift의 do try와 비슷하다

에러가 발생했을 떄 Error이벤트를로 종료되지 않게한다

Error 이벤트 대신 특정 값의 이벤트를 발생시키고 complete 시킨다.

( *catchError*를 한번이라도 타게되면, catch 이후의 모든 이벤트는 중단된다.)

![스크린샷 2022-10-31 오전 8.40.41.png](RxSwift%20Error%E1%84%8E%E1%85%A5%E1%84%85%E1%85%B5%20699618d7e19a40a0ad3327c0c6c415ae/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2022-10-31_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%258C%25E1%2585%25A5%25E1%2586%25AB_8.40.41.png)

기본값 defaultValue 으로 error 복구

# **CatchErrorJustReturn**

• Error 가 발생했을 때 Error 를 무시하고 element를 반환한다.

• **catchError**와 달리 에러 종류에 대한 구분이 필요 없을 때, 간결하게 표현할 수 있다.

• 모든 에러에 동일한 값이 반환되기 때문에 catchError 에 비해 제한적이다.

# retry()

![Untitled](RxSwift%20Error%E1%84%8E%E1%85%A5%E1%84%85%E1%85%B5%20699618d7e19a40a0ad3327c0c6c415ae/Untitled.png)

retry는 될때 까지 Observable을 시도하는 구문이다

단점은 될떄까지 시도한다

만약 인터넷 연결을 끊고 reload를 하면 콘솔에 실패 메세지가 계속 찍히는 것을 확인할 수 있다.

# **retry(_ maxAttemptCount: Int)**

![Untitled](RxSwift%20Error%E1%84%8E%E1%85%A5%E1%84%85%E1%85%B5%20699618d7e19a40a0ad3327c0c6c415ae/Untitled%201.png)

어탬트 = 시도

재시도를 몇번 할지 정해주는 것이다

• maxCount 가 3 이라면 총 3번의 요청을 보낸다. (재시도는 2번)

# TimeOut

일정 시간 동안 이벤트가 발생하지 않으면 에러를 발생시킨다.

![Untitled](RxSwift%20Error%E1%84%8E%E1%85%A5%E1%84%85%E1%85%B5%20699618d7e19a40a0ad3327c0c6c415ae/Untitled%202.png)

```
출력 결과를 보면 next(0) 이 방출되기 전에 3초동안 아무런 반응이 없다가 방출되는것을 확인할 수 있습니다.이후 2초마다 timer연산자를 통해 이벤트가 subject에 next 이벤트가 전달됩니다. .take(5) 를 통해 5번의 전달 이후 전달하지 않고. 3초의 outtime이 경과하면 other : Source 를 구독자에게 전달하며 종료됩니다.
```

[https://thoonk.tistory.com/93](https://thoonk.tistory.com/93)

[https://okanghoon.medium.com/rxswift-5-error-handling-example-9f15176d11fc](https://okanghoon.medium.com/rxswift-5-error-handling-example-9f15176d11fc)