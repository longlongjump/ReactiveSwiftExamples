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