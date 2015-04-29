//
//  RxRequest.swift
//  ReactiveSwiftExamples
//
//  Created by Eugene on 4/29/15.
//  Copyright (c) 2015 Eugen Ovchynnykov. All rights reserved.
//

import ReactiveCocoa
import Alamofire

public func rac_request(method: Alamofire.Method, URLString: URLStringConvertible, parameters: [String: AnyObject]? = nil) -> SignalProducer<AnyObject?, NSError> {
    return SignalProducer { observer, disposable in
        var http_request = Alamofire.request(method, URLString, parameters: parameters);
        
        disposable.addDisposable({
            http_request.cancel()
        });
        
        http_request.responseJSON { (_, _, JSON, error) in
            if let error = error {
                sendError(observer, error)
            }
            else
            {
                sendNext(observer, JSON)
                sendCompleted(observer)
            }
        }
    }
}