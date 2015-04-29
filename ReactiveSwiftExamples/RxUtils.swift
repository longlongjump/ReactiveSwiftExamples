//
//  RxUtils.swift
//  ReactiveSwiftExamples
//
//  Created by Eugen Ovchynnykov on 28.04.15.
//  Copyright (c) 2015 Eugen Ovchynnykov. All rights reserved.
//

import Foundation
import ReactiveCocoa

func eraseType<T, E>(signal: Signal<T,E>) -> Signal<AnyObject?, E> {
    return signal |> map { return $0 as? AnyObject }
}



func distinctUntilChanged<T, E where T:Equatable>(signal: Signal<T,E>) -> Signal<T, E> {
    return Signal { observer in
        var previous : T?
        var initial = true
        return signal.observe(Signal.Observer { event in
            switch event {
            case let .Next(value):
                if initial || value.unbox != previous! {
                    sendNext(observer, value.unbox)
                }
                previous = value.unbox
                initial = false
            default:
                observer.put(event)
            }
            })
    }
}


func merge<T,E>(signalList: Array<SignalProducer<T,E>>) -> SignalProducer<T, E>{
    return SignalProducer<SignalProducer<T,E>, E> { observer, disposable in
        for signal in signalList {
            sendNext(observer, signal)
        }
    } |> flatten(.Merge)
}


