//
//  View Model.swift
//  FirebaseUsingPhone
//
//  Created by Admin on 28/02/22.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn
import FirebaseDatabase

// New Change Google file


class ButtonActions {
    
    let ref = Database.database().reference()
    var userdata : GoogleUserInfo?
    
    func googleSignIn(controller: UIViewController,complesherHandler:@escaping ()->()) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(with: config, presenting: controller ) { [unowned self] user, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                return
            }
            let cridential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: cridential) { [weak self] authResult , error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    guard let fCMUser = authResult?.user
                    else {
                        return
                    }
                    //                    print(fCMUser.displayName)
                    guard let name = fCMUser.displayName, let email = fCMUser.email  else { return }
                    
                    let fmcModel = GoogleUserInfo(photoURL: fCMUser.photoURL , email: email, displayName: name, userID: fCMUser.uid, phoneNumber: fCMUser.phoneNumber)
                    self?.userdata = fmcModel
                    
                    complesherHandler()
                }
            }
        }
    }
    
    
    func addUserToRealtimeDB(name: String, email: String, userId: String, complisherHandler: @escaping()->()) {
        
        ref.child("Users").childByAutoId().setValue(["Name":name,"Email":email,"UserId":userId]) { error, reference in
            if let err = error {
                print(err.localizedDescription)
                
            } else {
                print("successfully added")
                complisherHandler()
            }
        }
    }
}

