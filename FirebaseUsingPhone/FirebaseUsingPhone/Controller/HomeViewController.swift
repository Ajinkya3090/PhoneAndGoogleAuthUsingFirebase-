//
//  HomeViewController.swift
//  FirebaseUsingPhone
//
//  Created by Admin on 24/02/22.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userID: UILabel!
    @IBOutlet weak var contactNumber: UILabel!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    
    @IBOutlet weak var realFireDB: UIButton!
    var userViewModel : ButtonActions?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = userViewModel?.userdata else { return }

        userName.text = user.displayName
        userEmail.text = user.email
        userID.text = user.userID
        
        
        if user.phoneNumber == nil {
            contactNumber.isHidden = true
            phoneNumberLbl.isHidden = true
        } else {
            phoneNumberLbl.isHidden = false
            contactNumber.isHidden = false
            contactNumber.text = user.phoneNumber ?? nil
        }
        
        guard let url = user.photoURL else { return }
            if let data = try? Data(contentsOf: url) {
                profileImage.image = UIImage(data: data)
            }
    }

    @IBAction func signOutBtn(_ sender: Any) {
        let firebaseAuth = Auth.auth()
         do {
             try firebaseAuth.signOut()
             navigationController?.popViewController(animated: true)
         } catch let signOutError as NSError {
             print("Error signing out: %@", signOutError)
         }
     }
    
    @IBAction func fireDBRealtime(_ sender: Any) {
        guard let name = userName.text, let email = userEmail.text, let userID = userID.text else { return }
        self.userViewModel?.addUserToRealtimeDB(name: name, email: email, userId: userID, complisherHandler: {
            print("Data added Sucessfully")
            self.navigationController?.popViewController(animated: true)
        })
    }
}

