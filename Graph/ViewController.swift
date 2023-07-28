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
        
        let myData = [
            ["Mon": 15],
            ["Tues" : 38],
            ["Weds" : 12],
            ["Thurs" : 30],
            ["Fri" : 30],
            ["Sat" : 15],
            ["Sun": 45]
        ]
        
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        let graphFrame = CGRectInset(CGRect(x: 0, y: 0, width: width, height: height), 20, 50)
        let graph = GraphView(frame: graphFrame, data: myData)
    
        self.view.addSubview(graph)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

