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
        
        guard self.loginTextField.text!.characters.count != 0,
              self.passwordTextField.text!.characters.count  != 0 ,
               self.rePasswordTextField.text!.characters.count  != 0 else {
                let infoAlert = UIAlertController(title: "EMPTY_TEXT_FIELD_ALLERT_TITLE".localized, message: "EMPTY_TEXT_FIELD_ALLERT_MESSAGE".localized, preferredStyle: .alert)
                let dissmisAction = UIAlertAction(title: "EMPTY_TEXT_FIELD_ALLERT_DISSMIS_BUTTON_TITLE".localized, style: .cancel, handler: { (action) in
                    infoAlert.dismiss(animated: true, completion: nil)
                })
                infoAlert.addAction(dissmisAction)
                
                self.navigationController?.present(infoAlert, animated: true, completion: nil)
                
            return
        }
        
        
        
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
