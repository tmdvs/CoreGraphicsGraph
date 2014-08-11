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
        // Do any additional setup after loading the view, typically from a nib.
        
        let myData = [NSNumber(int:10),
                    NSNumber(int:56),
                    NSNumber(int:34),
                    NSNumber(int:44),
                    NSNumber(int:12),
                    NSNumber(int:60),
                    NSNumber(int:54),
                    NSNumber(int:23),
                    NSNumber(int:53)] as NSArray
        
        let graph = GraphView(frame: CGRectMake(50, 50, 400, 200), data: myData)
        self.view.addSubview(graph)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

