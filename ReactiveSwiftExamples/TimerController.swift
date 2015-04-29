//
//  ViewController.swift
//  ReactiveSwiftExamples
//
//  Created by Eugen Ovchynnykov on 28.04.15.
//  Copyright (c) 2015 Eugen Ovchynnykov. All rights reserved.
//

import UIKit
import ReactiveCocoa


func startOfTheDay() -> NSDate {
    var comp = NSCalendar.currentCalendar().components((NSCalendarUnit.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay), fromDate: NSDate())
    return NSCalendar.currentCalendar().dateFromComponents(comp)!
}

func secondsToRadians(secondsPerRound: Int)(seconds : Double) -> Double {
    return seconds / Double(secondsPerRound/2) * M_PI - M_PI_2;
}


class TimerController: UIViewController {

    @IBOutlet weak var minutesView: UIView!
    @IBOutlet weak var hoursView: UIView!
    @IBOutlet weak var secondsView: UIView!
    
    
    func setupClock() {
        // emit every second
        var timeSignal = timer(1, onScheduler: QueueScheduler.mainQueueScheduler)
        
        // get seconds since days start
        var secondsSinceDayStartSignal = timeSignal |> map({return $0.timeIntervalSinceDate(startOfTheDay())})
        
        func radiansToTransform(val: Double) -> NSValue {
            return NSValue(CGAffineTransform: CGAffineTransformMakeRotation(CGFloat(val)))
        }
        
        var secondsSignal = secondsSinceDayStartSignal |> map(secondsToRadians(60)) |> map(radiansToTransform)
        var minutesSignal = secondsSinceDayStartSignal |> map(secondsToRadians(60*60)) |> map(radiansToTransform)
        var hoursSignal = secondsSinceDayStartSignal |> map(secondsToRadians(60*60*12)) |> map(radiansToTransform)
        
        DynamicProperty(object:self.secondsView, keyPath: "transform") <~ secondsSignal |> eraseType;
        DynamicProperty(object:self.minutesView, keyPath: "transform") <~ minutesSignal |> eraseType;
        DynamicProperty(object:self.hoursView, keyPath: "transform") <~ hoursSignal |> eraseType;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupClock()
    }

}

