//
//  LoginViewController.swift
//  Wat Next
//
//  Created by computer on 8/11/15.
//  Copyright (c) 2015 computer. All rights reserved.
//

import UIKit

class LoginViewController: UITabBarController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.delegate = self
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        screenSetup()
    }
    
    // MARK: Parse Login
    
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        if (!username.isEmpty) || (!password.isEmpty) {
            return true
        } else {
            return false
        }
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        print("failed to login", terminator: "")
    }
    
    // MARK: Parse Sign Up
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        print("sign up failed", terminator: "")
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        print("user dismissed sign up", terminator: "")
    }
    
    func screenSetup() {
        if PFUser.currentUser() == nil {
            let loginViewController = PFLogInViewController()
            loginViewController.delegate = self
            
            let signupViewController = PFSignUpViewController()
            signupViewController.delegate = self
            
            // 'signUpController' is a child of loginView, so here it's declared
            loginViewController.signUpController = signupViewController
            
            loginViewController.fields = ([PFLogInFields.UsernameAndPassword, PFLogInFields.LogInButton, PFLogInFields.SignUpButton, PFLogInFields.PasswordForgotten, PFLogInFields.DismissButton])
            
            // MARK: Login Customization
            
            loginViewController.logInView!.backgroundColor = UIColor.blackColor()
            
            // Creating custom logo for loginView
            let logoView = UILabel()
            logoView.text = "Whats Next"
            logoView.textColor = UIColor.whiteColor()
            let color = logoView.textColor
            
            logoView.font = UIFont(name: "Angelface", size: 75)
            logoView.layer.shadowColor = color.CGColor
            logoView.layer.shadowRadius = 4.0
            logoView.layer.shadowOpacity = 0.9
            logoView.layer.shadowOffset = CGSizeZero
            logoView.layer.masksToBounds = false
            let frame = UIScreen.mainScreen().bounds
            logoView.frame = CGRectMake(frame.size.width/2 - 140, 80, 280, 80)
            
            loginViewController.logInView!.logo = nil
            loginViewController.logInView!.addSubview(logoView)
            
            // Customize login and sign up buttons in Login
            
            loginViewController.logInView!.logInButton!.setBackgroundImage(UIImage(named: "black.png"), forState: UIControlState.Normal)
            
            loginViewController.logInView!.logInButton!.titleLabel?.font = UIFont(name: "Angelface", size: 60)
            
            loginViewController.logInView!.signUpButton!.setBackgroundImage(UIImage(named: "black.png"), forState: UIControlState.Normal)
            
            loginViewController.logInView!.signUpButton!.titleLabel?.font = UIFont(name: "Angelface", size: 60)
            
            loginViewController.logInView!.usernameField?.backgroundColor = UIColor.blackColor()
            loginViewController.logInView!.usernameField?.textColor = UIColor.whiteColor()
            
            loginViewController.logInView!.passwordField?.backgroundColor = UIColor.blackColor()
            loginViewController.logInView!.passwordField?.textColor = UIColor.whiteColor()
            
            loginViewController.logInView!.logInButton!.layer.shadowColor = color.CGColor
            loginViewController.logInView!.logInButton!.layer.shadowRadius = 4.0
            loginViewController.logInView!.logInButton!.layer.shadowOpacity = 0.9
            loginViewController.logInView!.logInButton!.layer.shadowOffset = CGSizeZero
            loginViewController.logInView!.logInButton!.layer.masksToBounds = false
            
            loginViewController.logInView!.signUpButton!.layer.shadowColor = color.CGColor
            loginViewController.logInView!.signUpButton!.layer.shadowRadius = 4.0
            loginViewController.logInView!.signUpButton!.layer.shadowOpacity = 0.9
            loginViewController.logInView!.signUpButton!.layer.shadowOffset = CGSizeZero
            loginViewController.logInView!.signUpButton!.layer.masksToBounds = false
            
            loginViewController.logInView!.passwordForgottenButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            
            // Custom logo for signUpView
            
            let signupLogoView = UILabel()
            signupLogoView.text = "Whats Next"
            signupLogoView.textColor = UIColor.whiteColor()
            
            
            signupLogoView.font = UIFont(name: "Angelface", size: 75)
            signupLogoView.layer.shadowColor = color.CGColor
            signupLogoView.layer.shadowRadius = 4.0
            signupLogoView.layer.shadowOpacity = 0.9
            signupLogoView.layer.shadowOffset = CGSizeZero
            signupLogoView.layer.masksToBounds = false
            
            signupLogoView.frame = CGRectMake(frame.size.width/2 - 140, 80, 280, 80)
            
            signupViewController.signUpView?.logo = nil
            signupViewController.signUpView?.addSubview(signupLogoView)
            
            signupViewController.signUpView?.signUpButton!.titleLabel?.font = UIFont(name: "Angelface", size: 60)
            
            // Customize signUpView
            
            signupViewController.signUpView!.backgroundColor = UIColor.blackColor()
            signupViewController.signUpView!.usernameField?.backgroundColor = UIColor.blackColor()
            signupViewController.signUpView!.usernameField?.textColor = UIColor.whiteColor()
            
            signupViewController.signUpView!.passwordField?.backgroundColor = UIColor.blackColor()
            signupViewController.signUpView!.passwordField?.textColor = UIColor.whiteColor()
            
            signupViewController.signUpView!.emailField?.backgroundColor = UIColor.blackColor()
            signupViewController.signUpView!.emailField?.textColor = UIColor.whiteColor()
            
            signupViewController.signUpView!.signUpButton!.setBackgroundImage(UIImage(named: "black.png"), forState: UIControlState.Normal)
            
            signupViewController.signUpView!.signUpButton!.titleLabel?.font = UIFont(name: "Angelface", size: 60)
            
            signupViewController.signUpView!.signUpButton!.layer.shadowColor = color.CGColor
            signupViewController.signUpView!.signUpButton!.layer.shadowRadius = 4.0
            signupViewController.signUpView!.signUpButton!.layer.shadowOpacity = 0.9
            signupViewController.signUpView!.signUpButton!.layer.shadowOffset = CGSizeZero
            signupViewController.signUpView!.signUpButton!.layer.masksToBounds = false
            
            
            self.presentViewController(loginViewController, animated: true, completion: nil)
        }
    }
}
