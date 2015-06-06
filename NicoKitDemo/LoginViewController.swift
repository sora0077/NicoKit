//
//  LoginViewController.swift
//  NicoKit
//
//  Created by 林達也 on 2015/06/06.
//  Copyright (c) 2015年 林達也. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var mailaddressField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mailaddressField.text = ENV.DEMO_NICO_MAILADDRESS
        passwordField.text = ENV.DEMO_NICO_PASSWORD
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func loginAction(sender: AnyObject) {
    
        if mailaddressField.text.isEmpty {
            return
        }
        if passwordField.text.isEmpty {
            return
        }
        
        let getSession = GetSession(mailaddress: mailaddressField.text, password: passwordField.text)
        NicoAPI.request(getSession).onSuccess {
            Logging.d($0.debugDescription)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoginViewController: Storyboardable {
    
    static var storyboardIdentifier: String {
        return "LoginViewController"
    }
    static var storyboardName: String {
        return "Main"
    }
}

