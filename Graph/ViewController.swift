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
            ["Mon": 15],
            ["Tues" : 30],
            ["Weds" : 7],
            ["Thurs" : 65],
            ["Fri" : 30],
            ["Sat" : 15],
            ["Sun": 45]
            ]
        
        
        let graph = GraphView(frame: CGRect(x: x, y: y, width: width-x*2, height: height * 0.5), data: myData)
        
        self.view.addSubview(graph)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

