//
//  NewsController.swift
//  ReactiveSwiftExamples
//
//  Created by Eugene on 4/29/15.
//  Copyright (c) 2015 Eugen Ovchynnykov. All rights reserved.
//

import UIKit
import ReactiveCocoa


class Buffer<T>
{
    var buffer : Array<T> = []
    var buffer_size = 1;
    
    init(_ size: Int)
    {
        buffer_size = size
    }
    
    func put(val : T) {
        if (buffer.count == buffer_size)
        {
            buffer.removeLast()
        }
        
        buffer.insert(val, atIndex: 0)
    }
    
    subscript(index: Int) -> T {
        return buffer[index]
    }
    
    func length() -> Int {
        return buffer.count
    }
}


class NewsController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var buffer = Buffer<String>(10);

    
    
    func startLoadingNews() {
        
        //var query = "https://ajax.googleapis.com/ajax/services/feed/find?v=1.0&q="
        var query = "http://echo.jsontest.com/title/timeout_is"
        
        var timeouts = [1, 2, 7, 3 , 4 , 6]
        
        
        var signals = timeouts.map { val in
            return timer(Double(val), onScheduler: QueueScheduler.mainQueueScheduler)
                    |> promoteErrors(NSError)
                    |> flatMap(FlattenStrategy.Concat, { _ in return rac_request(.GET, query + String(val))})
        }
        
        func parseJSON(json : AnyObject?) -> AnyObject {
            var val = json as! NSDictionary
            return val.objectForKey("title")!
         }
        
        merge(signals)
            |> map(parseJSON)
            |> map(toString)
            |> filter { count($0) > 3 }
            |> start(next: { val in
            self.buffer.put(val)
            self.tableView.reloadData()
        })
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = buffer[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buffer.length();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startLoadingNews()
    }
    
}