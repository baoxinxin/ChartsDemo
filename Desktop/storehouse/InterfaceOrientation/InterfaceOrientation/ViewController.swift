//
//  ViewController.swift
//  InterfaceOrientation
//
//  Created by ZLY on 16/10/18.
//  Copyright © 2016年 BX. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    

    @IBAction func ChoosePortrait(_ sender: AnyObject) {
        appDelegate.interfaceOrientation = UIInterfaceOrientationMask.portrait
        UIDevice.current.setValue(UIInterfaceOrientationMask.portrait.rawValue, forKey: "orientation")
    }

    @IBAction func chooseLandscapeLeft(_ sender: AnyObject) {
        appDelegate.interfaceOrientation = UIInterfaceOrientationMask.landscapeLeft
         UIDevice.current.setValue(UIInterfaceOrientationMask.landscapeLeft.rawValue, forKey: "orientation")
    }
    
    @IBAction func chooseLandscapeRight(_ sender: AnyObject) {
        appDelegate.interfaceOrientation = UIInterfaceOrientationMask.landscapeRight
        UIDevice.current.setValue(UIInterfaceOrientationMask.landscapeRight, forKey: "orientation")
    }
}

