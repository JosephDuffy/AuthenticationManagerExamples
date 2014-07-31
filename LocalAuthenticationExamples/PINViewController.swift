//
//  FirstViewController.swift
//  LocalAuthenticationExamples
//
//  Created by Joseph Duffy on 24/07/2014.
//  Copyright (c) 2014 Yetii Ltd. All rights reserved.
//

import UIKit
import AuthenticationManager

class PINViewController: UIViewController, PINSetupDelegate {

    var manager: AuthenticationManager = AuthenticationManager.sharedInstance
    @IBOutlet weak var currentCodeLabel: UILabel!
    @IBOutlet weak var setCodeButton: UIButton!
    @IBOutlet weak var updateCodeButton: UIButton!
    @IBOutlet weak var tsetCodeButton: UIButton!
    @IBOutlet weak var lastTestResultLabel: UILabel!
    @IBOutlet weak var resetPINButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup the buttons and labels
        self.updateUI()
    }

    func updateUI() {
        if let currentCode = self.manager.userDefaults.stringForKey(kAMPINKey) {
            self.currentCodeLabel.text = "Current PIN: \(currentCode)"
            self.setCodeButton.enabled = false
            self.updateCodeButton.enabled = true
            self.tsetCodeButton.enabled = true
            self.resetPINButton.enabled = true
        } else {
            // No PIN code has been set yet
            self.currentCodeLabel.text = "Current PIN: Not Set"
            self.setCodeButton.enabled = true
            self.updateCodeButton.enabled = false
            self.tsetCodeButton.enabled = false
            self.resetPINButton.enabled = false
        }
    }

    @IBAction func setCodeButtonWasPressed(sender: UIButton) {
        let viewController = self.manager.getAuthenticationSetupViewControllerForType(.PIN) as PINSetupViewController
        viewController.delegate = self
        self.presentViewController(viewController.viewInNavigationController(), animated: true, completion: nil)
    }

    @IBAction func updateCodeButtonWasPressed(sender: UIButton) {
    }

    @IBAction func testCodeButtonWasPressed(sender: UIButton) {
        let viewController: AuthenticationViewController = self.manager.getAuthenticationViewControllerForType(.PIN)
//        viewController.delegate = self
        self.presentViewController(viewController, animated: true, completion: nil)
    }

    @IBAction func resetPINButtonWasPressed(sender: UIButton) {
        self.manager.userDefaults.removeObjectForKey(kAMPINKey)
        self.manager.userDefaults.synchronize()
        self.updateUI()
    }

    func authenticationDidSucceed() {
        println("PIN correct")
    }

    /// PINSetupDelegate methods
    func setupCompleteWithPIN(PIN: String) {
        // Save the PIN to the user defaults
        self.manager.userDefaults.setValue(PIN, forKey: kAMPINKey)
        self.manager.userDefaults.synchronize()
        // Remove the popup view
        self.dismissViewControllerAnimated(true, completion: nil)
//        self.presentedViewController.removeFromParentViewController()
        // Update the UI
        self.updateUI()
    }
}

