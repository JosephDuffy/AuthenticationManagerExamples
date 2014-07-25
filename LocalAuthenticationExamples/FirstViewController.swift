//
//  FirstViewController.swift
//  LocalAuthenticationExamples
//
//  Created by Joseph Duffy on 24/07/2014.
//  Copyright (c) 2014 Yetii Ltd. All rights reserved.
//

import UIKit
import AuthenticationManager

class FirstViewController: UIViewController, AuthenticationDelegate {

    var manager: AuthenticationManager = AuthenticationManager.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let viewController: AuthenticationViewController = self.manager.createAuthenticationViewController(.PINCode)
        viewController.delegate = self
        self.addChildViewController(viewController)
        self.view.addSubview(viewController.view)
    }

    func authenticationDidSucceed() {
        println("PIN Code correct")
    }
}

