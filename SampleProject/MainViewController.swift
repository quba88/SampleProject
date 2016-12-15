//
//  MainViewController.swift
//  SampleProject
//
//  Created by Jakub Krystek on 06.12.2016.
//  Copyright © 2016 Jakub Krystek. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController!.viewControllers.removeAll()
        self.navigationController!.viewControllers = [self];
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

