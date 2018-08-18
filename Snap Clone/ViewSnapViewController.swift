//
//  ViewSnapViewController.swift
//  Snap Clone
//
//  Created by Brandon Hensley on 8/17/18.
//  Copyright © 2018 Brandon Hensley. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SDWebImage
import FirebaseAuth
import FirebaseStorage

class ViewSnapViewController: UIViewController {

    @IBOutlet weak var snapView: UIImageView!
    var snapShot : FIRDataSnapshot?
    @IBOutlet weak var messageLabel: UILabel!
    var imageName = ""
    var snapID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let snapShot = snapShot {
            if let snapDictionary = snapShot.value as? NSDictionary {
                if let from = snapDictionary["from"] as? String {
                    if let imageName = snapDictionary["imageName"] as? String {
                        if let imageURL = snapDictionary["imageURL"] as? String {
                            if let message = snapDictionary["message"] as? String {
                                
                                messageLabel.text = message
                                if let url = URL(string: imageURL) {
                                    
                                    snapView.sd_setImage(with: url, completed: nil)
                                    self.imageName = imageName
                                    self.snapID = snapShot.key
                                }
                                
                            }
                        }
                    }
                }
            }
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            
            FIRDatabase.database().reference().child("users").child(uid).child("snaps").child(snapID).removeValue()
            FIRStorage.storage().reference().child("images").child(imageName).delete(completion: nil)
            
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
