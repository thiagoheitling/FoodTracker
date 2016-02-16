//
//  ProfileViewController.swift
//  FoodTracker
//
//  Created by Thiago Heitling on 2016-02-15.
//  Copyright © 2016 Thiago Heitling. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {

    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var foodPreferenceTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let user = PFUser.currentUser()
        userNameTextField.text = user?.username
        foodPreferenceTextField.text = user?.objectForKey("foodOption") as? String
        
        let profilePic = user?.objectForKey("profilePicture") as? PFFile
        
        profilePic?.getDataInBackgroundWithBlock({ (data, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.profilePictureImageView?.image = UIImage(data: data!)
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonPressed(sender: UIButton) {
        // Send a request to log out a user
        PFUser.logOut()
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginVC")
            self.presentViewController(viewController, animated: true, completion: nil)
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
