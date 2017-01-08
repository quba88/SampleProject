//
//  CrateAccountViewController.swift
//  SampleProject
//
//  Created by Jakub Krystek on 06.12.2016.
//  Copyright © 2016 Jakub Krystek. All rights reserved.
//

import UIKit

class CrateAccountViewController: UIViewController, UITextFieldDelegate {
// MARK: - IBOutletes
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
    
    // MARK: - VC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
// MARK: - IBAction
    @IBAction func subbmitButtonAction(_ sender: UIButton) {
        
     /// validation
        
        guard !self.loginTextField.text!.isEmpty,
            !self.passwordTextField.text!.isEmpty,
            !self.rePasswordTextField.text!.isEmpty else {
                let infoAlert = UIAlertController(title: "EMPTY_ALLERT_TITLE".localized, message: "EMPTY_ALLERT_MESSAGE".localized, preferredStyle: .alert)
                let dissmisAction = UIAlertAction(title: "EMPTY_ALLERT_DISSMIS_BUTTON_TITLE".localized, style: .cancel, handler: { (action) in
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
            
            self.navigationController!.present(infoAlert, animated: true, completion: nil)
            
            return
        }
        

        do{
            // ???: automaticly login user
     let _ = try KeychainWrapper.createAccount(login: self.loginTextField.text!, password: self.passwordTextField.text!)
            
            let infoAlert = UIAlertController(title: "SUCESS_CREATE_ACCOUNT_ALLERT_TITLE".localized, message: "SUCESS_CREATE_ACCOUNT_ALLERT_MESSAGE".localized, preferredStyle: .alert)
            
            let dissmisAction = UIAlertAction(title: "SUCESS_CREATE_ACCOUNT_ALLERT_DISMIS_BUTTON".localized, style: .cancel, handler: {  [unowned self] (action) in
                infoAlert.dismiss(animated: true, completion: nil)
                self.navigationController!.popViewController(animated: true)
            })
            
            infoAlert.addAction(dissmisAction)
            self.navigationController!.present(infoAlert, animated: true, completion: nil)
        }
        catch KeychainWrapperError.exist{
            let infoAlert = UIAlertController(title: "ACCOUNT_EXIST_ALLERT_TITLE".localized, message: "ACCOUNT_EXIST_ALLERT_MESSAGE".localized, preferredStyle: .alert)
            
            let dissmisAction = UIAlertAction(title: "ACCOUNT_EXIST_ALLERT_DISSMIS_BUTTON_TITLE".localized, style: .cancel, handler: {  [unowned self] (action) in
                infoAlert.dismiss(animated: true, completion: nil)
                self.navigationController!.popViewController(animated: true)
            })
            
            infoAlert.addAction(dissmisAction)
            self.navigationController!.present(infoAlert, animated: true, completion: nil)
        }
            
        catch {
            
            let message = String.localizedStringWithFormat( "CREATE_ACCOUNT_ERROR_ALLERT_MESSAGE".localized,  "\(error)")
            let infoAlert = UIAlertController(title: "CREATE_ACCOUNT_ERROR_ALLERT_TITLE".localized, message: message, preferredStyle: .alert)
            
            let dissmisAction = UIAlertAction(title: "CREATE_ACCOUNT_ERROR_ALLERT_DISSMIS_BUTTON_TITLE".localized, style: .cancel, handler: {  [unowned self] (action) in
                infoAlert.dismiss(animated: true, completion: nil)
                self.navigationController!.popViewController(animated: true)
            })
            
            infoAlert.addAction(dissmisAction)
            self.navigationController!.present(infoAlert, animated: true, completion: nil)
            
            print(error)
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
