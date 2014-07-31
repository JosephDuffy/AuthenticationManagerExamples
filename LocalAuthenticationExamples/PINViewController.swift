//
//  FirstViewController.swift
//  LocalAuthenticationExamples
//
//  Created by Joseph Duffy on 24/07/2014.
//  Copyright (c) 2014 Yetii Ltd. All rights reserved.
//

import UIKit
import AuthenticationManager

class PINViewController: UIViewController, AuthenticationDelegate, PINSetupDelegate, PINAuthenticationDelegate {

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
        viewController.setupDelegate = self
        self.presentViewController(viewController.viewInNavigationController(), animated: true, completion: nil)
    }

    @IBAction func updateCodeButtonWasPressed(sender: UIButton) {
    }

    @IBAction func testCodeButtonWasPressed(sender: UIButton) {
        let viewController = self.manager.getAuthenticationViewControllerForType(.PIN) as PINAuthenticationViewController
        viewController.delegate = self
        viewController.authenticationDelegate = self
        let currentPIN = self.manager.userDefaults.stringForKey(kAMPINKey);
        assert(currentPIN != nil, "Cannot test PIN with no PIN set")
        viewController.PIN = currentPIN
        self.presentViewController(viewController.viewInNavigationController(), animated: true, completion: nil)
    }

    @IBAction func resetPINButtonWasPressed(sender: UIButton) {
        self.manager.userDefaults.removeObjectForKey(kAMPINKey)
        self.manager.userDefaults.synchronize()
        self.updateUI()
    }

    /// AuthenticationDelegate methods

    func authenticationWasCanceled(viewController: AuthenticationViewController) {
        if viewController is PINAuthenticationViewController {
            self.lastTestResultLabel.text = "Last Result: Canceled"
        }
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

    /// PINAuthenticationDelegate methods

    func authenticationDidSucceed() {
        self.lastTestResultLabel.text = "Last Result: Authenticated"
        self.presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }

    func inputPINWasIncorrect(PIN: String) {
        self.lastTestResultLabel.text = "Last Result: Input PIN was incorrect"
    }

    func PINWasInput(PIN: String) {
        self.lastTestResultLabel.text = "Last Result: PIN was input"
    }
}

