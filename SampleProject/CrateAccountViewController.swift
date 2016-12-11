//
//  CrateAccountViewController.swift
//  SampleProject
//
//  Created by Jakub Krystek on 06.12.2016.
//  Copyright © 2016 Jakub Krystek. All rights reserved.
//

import UIKit

class CrateAccountViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func subbmitButtonAction(_ sender: UIButton) {
        
     /// validation
        
        guard !self.loginTextField.text!.isEmpty,
            !self.passwordTextField.text!.isEmpty,
            !self.rePasswordTextField.text!.isEmpty else {
                let infoAlert = UIAlertController(title: "EMPTY_TEXT_FIELD_ALLERT_TITLE".localized, message: "EMPTY_TEXT_FIELD_ALLERT_MESSAGE".localized, preferredStyle: .alert)
                let dissmisAction = UIAlertAction(title: "EMPTY_TEXT_FIELD_ALLERT_DISSMIS_BUTTON_TITLE".localized, style: .cancel, handler: { (action) in
                    infoAlert.dismiss(animated: true, completion: nil)
                })
                infoAlert.addAction(dissmisAction)
                
                self.navigationController?.present(infoAlert, animated: true, completion: nil)
                
                return
        }
        
        guard self.passwordTextField.text! == self.rePasswordTextField.text! else{
        
            let infoAlert = UIAlertController(title: "PASSWORD_NOT_MATCH_ALLERT_TITLE".localized, message: "PASSWORD_NOT_MATCH_ALLERT_MESSAGE".localized, preferredStyle: .alert)
            let dissmisAction = UIAlertAction(title: "PASSWORD_NOT_MATCH_ALLERT_DISSMIS_BUTTON_TITLE".localized, style: .cancel, handler: { (action) in
                infoAlert.dismiss(animated: true, completion: nil)
            })
            infoAlert.addAction(dissmisAction)
            
            self.navigationController?.present(infoAlert, animated: true, completion: nil)
            
            return
        }
        
        ///validation success save pasword & login to keychain
        
        
    }

// MARK: - TextField delegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        if textField == self.loginTextField{
        self.passwordTextField.becomeFirstResponder()
        }else
            if textField == self.passwordTextField{
        self.rePasswordTextField.becomeFirstResponder()
        }
        
        
        return true;
    }
    

}
