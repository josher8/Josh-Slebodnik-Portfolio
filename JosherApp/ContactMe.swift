//
//  ContactMe.swift
//  JosherApp
//
//  Created by Josher Slebodnik on 9/27/15.
//  Copyright © 2015 Josh Slebodnik. All rights reserved.
//

import UIKit
import Parse

class ContactMe: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet weak var nameField: UITextField!

    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var messageField: UITextView!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var contactView: UIView!
    
    @IBOutlet weak var topText: UILabel!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Contact Josh"
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action:"dismissKeyboard")
        
        self.view.addGestureRecognizer(tap)
        nameField.delegate = self
        emailField.delegate = self
        messageField.delegate = self
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func submitPressed(sender: UIButton) {
        if(!nameField.hasText() || !emailField .hasText() || !messageField.hasText() ){
            let alert = UIAlertController(title: "All fields must be filled out.", message:nil, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
            activityIndicator.center = view.center
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            self.contactView.hidden = true
            
            let data:PFObject = PFObject(className:"contact")
            data["name"] = nameField.text
            data["email"] = emailField.text
            data["message"] = messageField.text
            data.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError?) -> Void in
                if succeeded{
                    self.topText.text = "Your message has been successfully sent! Thank you!"
                    self.activityIndicator.stopAnimating()
                }else{
                    self.activityIndicator.stopAnimating()
                    self.contactView.hidden = false
                    let alert = UIAlertController(title: "There was an error on sending your message. Please try again.", message:nil, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)                    
                }
            })
        }
    }
    
    
    func dismissKeyboard(){
        nameField.resignFirstResponder()
        emailField.resignFirstResponder()
        messageField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            messageField.resignFirstResponder()
            return false
        }
        return true
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
