//
//  LoginViewController.swift
//  SampleProject
//
//  Created by Jakub Krystek on 06.12.2016.
//  Copyright © 2016 Jakub Krystek. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginUser(_ sender: UIButton) {
        
        guard !self.loginTextField.text!.isEmpty,
            !self.passwordTextField.text!.isEmpty else {
                let infoAlert = UIAlertController(title: "EMPTY_TEXT_FIELD_ALLERT_TITLE".localized,
                                                  message: "EMPTY_TEXT_FIELD_ALLERT_MESSAGE".localized,
                                                  preferredStyle: .alert)
                
                let dissmisAction = UIAlertAction(title: "EMPTY_TEXT_FIELD_ALLERT_DISSMIS_BUTTON_TITLE".localized,
                                                  style: .cancel,
                                                  handler: { (action) in
                    infoAlert.dismiss(animated: true, completion: nil)
                })
                infoAlert.addAction(dissmisAction)
                
                self.navigationController!.present(infoAlert, animated: true, completion: nil)
                
                return
        }
        var match:Bool = false;
        do{
            match = try KeychainWrapper.validateUserAccess(login: self.loginTextField.text!, password: self.passwordTextField.text!)
        }catch{
        
        print(error)
        
        }
        
        if match{
        ///Sucesss login move to main view
        
        }
        else{
        /// wrong (password or login) or error occurs
        
        }
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
