//
//  ViewController.swift
//  FirebaseUsingPhone
//
//  Created by Admin on 23/02/22.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class ViewController: UIViewController {
    @IBOutlet weak var phoneNumber_TF: UITextField!
    @IBOutlet weak var enterOTP_TF: UITextField!

    var userViewModel = ButtonActions()

    var verification_Id :String? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if Auth.auth().currentUser != nil {
            self.navigateToHomeVC()
        }
        enterOTP_TF.isHidden = true
        
    }
    
    @IBAction func googleBtnAction(_ sender: Any) {
        userViewModel.googleSignIn(controller: self) {
            self.navigateToHomeVC()
        }
    }
    
    private func navigateToHomeVC() {
        
        if let homeViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
            homeViewControllerObj.userViewModel = userViewModel
            navigationController?.pushViewController(homeViewControllerObj, animated: true)
        }
    }
    
    @IBAction func btnAction(_ sender: Any) {
        if enterOTP_TF.isHidden {
            if !phoneNumber_TF.text!.isEmpty {
                Auth.auth().settings?.isAppVerificationDisabledForTesting = true
                PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber_TF.text ?? "", uiDelegate: nil) { (verificationID, error) in
                    if error != nil {
                        return
                    } else {
                        self.verification_Id = verificationID
                        self.enterOTP_TF.isHidden = false
                    }
                }
            }else {
                print("Please Enter your phone number")
            }
        } else {
            if verification_Id != nil {
                let credential = PhoneAuthProvider.provider().credential(withVerificationID: verification_Id!, verificationCode: enterOTP_TF.text!)
                Auth.auth().signIn(with: credential) { (authData, error) in
                    if error != nil {
                        print(error.debugDescription)
                    } else {
                        let alert = UIAlertController(title: "", message: "Login Succesful with" +  (authData?.user.phoneNumber ?? ""), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }else {
            }
        }
    }
}

