//
//  ViewController.swift
//  Collections
//
//  Created by Megan Weijiang on 2/23/17.
//  Copyright © 2017 Megan Weijiang. All rights reserved.
//

import UIKit
import os.log

class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var item : Item?
    
    // Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var favoriteButton: FavoriteControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        descriptionTextView.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        descriptionTextView?.delegate = self
        descriptionTextView.layer.borderWidth = 1;
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor;
        descriptionTextView.layer.cornerRadius = 5;
        descriptionTextView.text = "Enter a description"
        descriptionTextView.textColor = UIColor.lightGray
        if (item?.description != nil) {
            descriptionTextView.textColor = UIColor.black
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        // Set up views if editing an existing Item.
        if let item = item {
            navigationItem.title = item.name
            nameTextField.text   = item.name
            photoImageView.image = item.photo
            descriptionTextView.text = item.description
            favoriteButton.favorite = item.favorite
        }
        
        updateSaveButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Text view functions
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.textColor = UIColor.black
        if item?.description == nil{
            textView.text = nil
        }
        else {
            textView.text = item?.description
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == nil {
            textView.text = "Enter a description"
            textView.textColor = UIColor.lightGray
        }
        else {
            navigationItem.title = textView.text
            item?.description = textView.text
        }
    }
    
    
    // Camera functions

    @IBAction func openCamera(_ sender: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Name Text Field Functions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    // Keyboard Functions
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            if descriptionTextView.isFirstResponder {
                self.view.frame.origin.y -= keyboardHeight
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            if descriptionTextView.resignFirstResponder() {
                self.view.frame.origin.y += keyboardHeight
            }
        }
    }
    
    // Navigation functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let favorite = favoriteButton.favorite
        let description = descriptionTextView.text
        
        // Set the item to be passed to ItemTableViewController after the unwind segue.
        item = Item(name: name, photo: photo, description: description, favorite: favorite)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The ViewController is not inside a navigation controller.")
        }
    }
    
    
    // Save button functions
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}

