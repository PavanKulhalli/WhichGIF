//
//  ViewController.swift
//  WhichGIF
//
//  Created by Pavan Kulhalli on 09/04/2018.
//  Copyright © 2018 COMP47390-41550. All rights reserved.
//

import UIKit
import GiphyCoreSDK

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundImage.png")!)
        GiphyCore.configure(apiKey: "pw8eC5lEliRHeJUypoqaPsUT84ampaFa")
    }

   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

