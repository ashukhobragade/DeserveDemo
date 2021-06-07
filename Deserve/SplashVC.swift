//
//  ViewController.swift
//  Deserve
//
//  Created by Ashish Khobragade on 07/06/21.
//

import UIKit

class SplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sleep(2)
        self.performSegue(withIdentifier: "LaunchSegue", sender: nil)
    }

}

