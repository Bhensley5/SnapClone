//
//  AddImageViewController.swift
//  Snap Clone
//
//  Created by Brandon Hensley on 8/8/18.
//  Copyright © 2018 Brandon Hensley. All rights reserved.
//

import UIKit
import FirebaseStorage

class AddImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    var imagePicker = UIImagePickerController()
    var imageURL = ""
    var imageName = "\(NSUUID().uuidString).jpeg"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func folderTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
            if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                imageView.image = selectedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        imagePicker.sourceType = .camera
    }
    
    @IBAction func addTapped(_ sender: Any) {
        let imageFolder = FIRStorage.storage().reference().child("images")
        if let image = imageView.image {
            if let imageData = UIImageJPEGRepresentation(image, 0.1) {
                imageFolder.child(imageName).put(imageData, metadata: nil) { (metadata, error) in
                    if let error = error {
                        print(error)
                    } else {
                        if let imageURL = metadata?.downloadURL()?.absoluteString {
                            self.imageURL = imageURL
                            self.performSegue(withIdentifier: "addContact", sender: nil)
                        }
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addContact = segue.destination as? AddContactTableViewController {
            addContact.imageURL = imageURL
            addContact.imageName = imageName
            if let message = textField.text {
                addContact.message = message
            }
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
