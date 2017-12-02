//
//  ViewController.swift
//  Graph
//
//  Created by Tim Davies on 11/08/2014.
//  Copyright (c) 2014 Tim Davies. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let x: CGFloat = 10
        let y: CGFloat = 50
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        let myData = [
            ["label" : "Mon",   "value" : 15],
            ["label" : "Tues",  "value" : 30],
            ["label" : "Weds",  "value" : 7],
            ["label" : "Thurs", "value" : 10],
            ["label" : "Fri",   "value" : 30],
            ["label" : "Sat",   "value" : 15],
            ["label" : "Sun",   "value" : 45],
        ]
        
        let graph = GraphView(frame: CGRect(x: x, y: y, width: width-x*2, height: height * 0.5), data: myData as NSArray)
        
        self.view.addSubview(graph)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

