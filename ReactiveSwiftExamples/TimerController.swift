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


class TimerController: UIViewController {

    @IBOutlet weak var minutesView: UIView!
    @IBOutlet weak var hoursView: UIView!
    @IBOutlet weak var secondsView: UIView!
    @IBOutlet weak var clockLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var timeSignal = timer(1, onScheduler: QueueScheduler.mainQueueScheduler)
        
        var day_seconds_signal = timeSignal |> map({return $0.timeIntervalSinceDate(startOfTheDay())})
        
        timeSignal |> map(toString) |> start(next: { NSLog($0) })
        
        func makeRotation(val: Double) -> NSValue {
            return NSValue(CGAffineTransform: CGAffineTransformMakeRotation(CGFloat(val)))
        }
        
        var seconds = day_seconds_signal |> map { (($0/30) * 3.1415) - 3.1415/2 } |> map(makeRotation)
        var minutes = day_seconds_signal |> map { ($0/(60*30)) * 3.1415 - 3.1415/2 } |> map(makeRotation)
        var hours = day_seconds_signal |> map { (($0/(60*60*6)) * 3.1415) - 3.1415/2 } |> map(makeRotation)
        
        
        DynamicProperty(object:self.secondsView, keyPath: "secondsView.transform") <~ seconds |> eraseType;
        DynamicProperty(object:self.minutesView, keyPath: "minutesView.transform") <~ minutes |> eraseType;
        DynamicProperty(object:self.hoursView, keyPath: "hoursView.transform") <~ hours |> eraseType;
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

