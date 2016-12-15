//
//  LoginViewController.swift
//  SampleProject
//
//  Created by Jakub Krystek on 06.12.2016.
//  Copyright © 2016 Jakub Krystek. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
// MARK: - outlets
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    
    // MARK: - VC life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBAction
    @IBAction func loginUser(_ sender: UIButton) {
        guard !self.loginTextField.text!.isEmpty,
            !self.passwordTextField.text!.isEmpty else {
                let infoAlert = UIAlertController(title: "EMPTY_ALLERT_TITLE".localized,
                                                  message: "EMPTY_ALLERT_MESSAGE".localized,
                                                  preferredStyle: .alert)
                
                let dissmisAction = UIAlertAction(title: "EMPTY_ALLERT_DISSMIS_BUTTON_TITLE".localized,
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
            self.performSegue(withIdentifier: "sucessLogin", sender: nil)
        }
        else{
            /// wrong (password or login) or error occurs
            
            let infoAlert = UIAlertController(title: "VALIDATION_ACCOUNT_DATA_ERROR_ALERT_VIEW_TITLE".localized,
                                              message: "VALIDATION_ACCOUNT_DATA_ERROR_ALERT_VIEW_MESSAGE".localized,
                                              preferredStyle: .alert)
            
            let dissmisAction = UIAlertAction(title: "VALIDATION_ACCOUNT_DATA_ERROR_ALERT_VIEW_DISSMIS_BUTON".localized,
                                              style: .cancel,
                                              handler: { (action) in
                                                infoAlert.dismiss(animated: true, completion: nil)
            })
            infoAlert.addAction(dissmisAction)
            
            self.navigationController!.present(infoAlert, animated: true, completion: nil)
            
        }
    }
    
    // MARK: - textfiled delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.loginTextField{
            textField.resignFirstResponder()
            self.passwordTextField.becomeFirstResponder();
        }
        
        return true;
    }
    

}
