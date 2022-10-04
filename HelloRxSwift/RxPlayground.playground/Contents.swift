import Foundation

import RxSwift
import RxCocoa
import PlaygroundSupport

/// MARK:  Observable
// MARK: - Observable 만들기 (Observable, just, of, from)

var observable1 = Observable.just(1) // Observable<Int>
var observable2 = Observable.of(1,2,3,4,5) // Observable<Int>
var observable3 = Observable.of([1,2,3,4,5]) // Observable<[Int]>
var observable4 = Observable.from([1,2,3,4,5]) // Observable<Int>

// MARK: - Observable 출력해보기 (subscribe, onNext, onCompleted)

observable4
    .subscribe { event in
        print(event)
    }

observable3
    .subscribe { event in
        if let element = event.element {
            print(element)
        }
        if event.isCompleted {
            print("Completed")
        }
    }

observable4
    .subscribe { event in
        if let element = event.element {
            print(element)
        }
        if event.isCompleted {
            print("Completed")
        }
    }

let subscription = observable4
    .subscribe(
        onNext: { element in
            print(element)
        }, onCompleted: {
            print("Completed")
        })

// MARK: Custom Observer 만들기 (create, disposable, disposBag)

let disposeBag = DisposeBag()

Observable
    .create { observer in
        observer.onNext("A")
        observer.onCompleted()
        observer.onNext("?")
        return Disposables.create()
    }.subscribe(
        onNext: {
            print($0)
        }, onError: {
            print($0)
        }, onCompleted: {
            print("Completed")
        }, onDisposed: {
            print("Disposed")
        }
    ).disposed(by: disposeBag)



/// MARK: - Subject
// MARK: - subject

//let observable: Observable<String>
//
//observable.onNext("Issue 1")

let subject = PublishSubject<String>()

subject.subscribe { event in
    print(event)
}

subject.onNext("Issue 1")

subject.subscribe { event in
    print(event)
}

subject.onNext("Issue 2")
subject.onNext("Issue 3")

subject.dispose()

subject.onCompleted()

subject.onNext("Issue 4")

// MARK: - Behavior Subjects

let behaviorSubject = BehaviorSubject<String>(value: "Initial Value")

behaviorSubject.subscribe { event in
    print(event)
}

// MARK: - Replay Subject

let replaySubject = ReplaySubject<String>.create(bufferSize: 2)

replaySubject.onNext("Issue 1")
replaySubject.onNext("Issue 2")
replaySubject.onNext("Issue 3")

replaySubject.subscribe {
    print($0)
}

replaySubject.onNext("Issue 4")

print("--------- New Subscriber ----------")

replaySubject.subscribe {
    print($0)
}

// MARK: - BehaviorRelay - RxCocoa가 필요, Variable이 Deprecated되고 나옴

let stringRelay = BehaviorRelay(value: "Initial Value")

stringRelay.asObservable()
    .subscribe {
        print($0)
    }

//stringRelay.value = "Hello World"

stringRelay.accept("Hello World")

let arrayRelay = BehaviorRelay(value: ["Banana"])

arrayRelay.asObservable()
    .subscribe {
        print($0)
    }


//arrayRelay.value.append("Kiwi") - Immutable한 값임

arrayRelay.accept(["Apple"])
arrayRelay.accept(arrayRelay.value + ["Pineapple"])

var value = arrayRelay.value
value.append("Kiwi")
arrayRelay.accept(value)


/// MARK: - Filtering Operators
// MARK: - Ignore element

let strikes = PublishSubject<String>()

//strikes
//    .ignoreElements()
//    .subscribe { event in
//        print("\(event)")
//    }.disposed(by: disposeBag)
//
//strikes.onNext("A")
//strikes.onNext("B")
//strikes.onNext("C")
//
//strikes.onCompleted() // Marbles랑 다르게 Completed가 일어나면 subscribe가 출력이 됨

// MARK: - Element At

//strikes.element(at: 2)
//    .subscribe(onNext: { element in
//        print("\(element)")
//    }).disposed(by: disposeBag)
//
//strikes.onNext("A")
//strikes.onNext("B")
//strikes.onNext("C")

// MARK: - Filter

Observable.of(1,2,3,4,5,6,7)
    .filter { $0 % 2 == 0 }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


// MARK: - Skip


Observable.of(1,2,3,4,5,6,7)
    .skip(2)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

// MARK: - Skip While

print("-------- Skip While -----------")

Observable.of(1,3,5,6,7,9,11)
    .skip(while: { $0 % 2 == 1 })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

// MARK: - Skip Until

let subjectForSkipUntil = PublishSubject<String>()
let trigger = PublishSubject<String>()

subjectForSkipUntil
    .skip(until: trigger)
    .subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)


subjectForSkipUntil.onNext("A")
subjectForSkipUntil.onNext("B")

trigger.onNext("X")

subjectForSkipUntil.onNext("C")
