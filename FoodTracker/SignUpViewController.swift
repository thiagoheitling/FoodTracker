//
//  SignUpViewController.swift
//  FoodTracker
//
//  Created by Thiago Heitling on 2016-02-15.
//  Copyright © 2016 Thiago Heitling. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: Properties
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var foodOptionPickerView: UIPickerView!
    var foodOption: String!

    let pickerData = ["Food Critic", "Casual Foodie"]
    var imageFile:PFFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userNameTextField.delegate = self
        passwordTextField.delegate = self
        foodOptionPickerView.dataSource = self
        foodOptionPickerView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView.contentMode = .ScaleAspectFill
            profileImageView.image = pickedImage
            
            if let data = UIImageJPEGRepresentation(pickedImage, 0.5) {
                imageFile = PFFile(data: data)
                imageFile.saveInBackground()
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UIPickerControllerDelegate
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        foodOption = pickerData[row]
        return pickerData[row]
    }
    
    // MARK: Actions
    
    @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
        textFieldShouldReturn(userNameTextField)
        textFieldShouldReturn(passwordTextField)
        foodOptionPickerView.resignFirstResponder()
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .PhotoLibrary
        imagePickerController.delegate = self
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func signUpButtonPressed(sender: UIButton) {
        
        let user = PFUser();
        
        user.username = userNameTextField.text
        user.password = passwordTextField.text
        user.setObject(foodOption, forKey: "foodOption")
        user.setObject(imageFile, forKey: "profilePicture")
        user.signUpInBackgroundWithBlock ({ (success, error) -> Void in
            if success {
                print("\(user) signup successfully")
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        })
    }
}
