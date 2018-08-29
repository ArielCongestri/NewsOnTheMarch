//
//  SingUpStoryboardViewController.swift
//  Proyecto Integrador
//
//  Created by Familia Congestri on 26/7/18.
//  Copyright © 2018 Digital House. All rights reserved.
//

import UIKit
import Firebase

class SingUpStoryboardViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var logInButton: UIButton!
	@IBAction func toLoginPressed(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
    @IBOutlet weak var plusPhotoButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    var ref: DatabaseReference!
    var storageRef: StorageReference!
    var chargedImage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        setupLogInButton()
        setupSingUpButton()
        setupPlusPhotoButton()
        setupPasswordTextField()
        setUpEmailTextField()
        setupUsernameTextField()
        setupBackgroundImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func setupPlusPhotoButton(){
        plusPhotoButton.setImage(#imageLiteral(resourceName: "plus_photo "), for: .normal)
        plusPhotoButton.tintColor = UIColor(red: 253/255, green: 203/255, blue: 0/255, alpha: 1)
    }
    func setUpEmailTextField(){
        emailTextField.placeholder = "Email"
        emailTextField.backgroundColor = UIColor(white: 1, alpha: 0.9)
        emailTextField.borderStyle = .roundedRect
        emailTextField.font = UIFont.systemFont(ofSize: 14)
		emailTextField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
		
    }
    func setupUsernameTextField(){
        usernameTextField.placeholder = "Username"
        usernameTextField.backgroundColor = UIColor(white: 1, alpha: 0.9)
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.font = UIFont.systemFont(ofSize: 14)
		usernameTextField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
    }
    func setupPasswordTextField(){
        passwordTextField.placeholder = "Password"
        passwordTextField.backgroundColor = UIColor(white: 1, alpha: 0.9)
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.font = UIFont.systemFont(ofSize: 14)
        passwordTextField.isSecureTextEntry = true
		passwordTextField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
    }
    func setupSingUpButton(){
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.backgroundColor = UIColor(red: 1, green: 218/255, blue: 68/255, alpha: 0.6)
        signUpButton.layer.cornerRadius = 5
        signUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        signUpButton.setTitleColor(.white, for: .normal)
    }
	
	@objc func handleTextInputChange() {
		let isFormValid = emailTextField.text?.count ?? 0 > 0 && usernameTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
		
		if isFormValid {
			signUpButton.isEnabled = true
			signUpButton.backgroundColor = UIColor(red: 1, green: 218/255, blue: 68/255, alpha: 0.95)
		} else {
			signUpButton.isEnabled = false
			signUpButton.backgroundColor = UIColor(red: 1, green: 218/255, blue: 68/255, alpha: 0.6)
		}
	}
    func setupLogInButton(){
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.white])
        
        attributedTitle.append(NSAttributedString(string: "Log in!", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor(red: 1, green: 218/255, blue: 68/255, alpha: 1)
            ]))
        
        logInButton.setAttributedTitle(attributedTitle, for: .normal)
    }
    fileprivate func setupBackgroundImage() {
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "loginBackgroundDark"))
    }
    

    @IBAction func plusPhotoButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
            
            let pickerController = UIImagePickerController()
            pickerController.sourceType = .camera
            pickerController.delegate = self
            self.present(pickerController, animated: true, completion: nil)
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { (_) in
            
            let pickerController = UIImagePickerController()
            pickerController.sourceType = .photoLibrary
            pickerController.delegate = self
            self.present(pickerController, animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController,animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            chargedImage = true
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
            chargedImage = true
        }
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor(red: 1, green: 218/255, blue: 68/255, alpha: 0.95).cgColor
        plusPhotoButton.layer.borderWidth = 3
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func singUpButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text, email.count > 0 else { return }
        guard let username = usernameTextField.text, username.count > 0 else { return }
        guard let password = passwordTextField.text, password.count > 0 else { return }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error: Error?) in
            
            if let err = error {
                print("Failed to create user:", err)
                return
            }
            print("Successfully created user:", user?.user.uid ?? "")
            
            
            guard let image = self.plusPhotoButton.imageView?.image else { return }
            
            guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else { return }
            print(uploadData)
            
            //let filename = NSUUID().uuidString
            
            let storageRef = Storage.storage().reference().child("profile_image").child((user?.user.uid)!)
            
            if self.chargedImage {
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if let error = error {
                        print("Failed to upload profile image: ", error)
                        return
                    }
                    
                    storageRef.downloadURL(completion: { (downloadURL, error) in
                        if let error = error {
                            print("Failed to fetch downloadURL: ,", error)
                            return
                        }
                        guard let profileImageUrl = downloadURL?.absoluteString else { return }
                        
                        print("Succesfully uploaded profile image: ", profileImageUrl)
                        
                        guard let uid = user?.user.uid else { return }
                        
                        let dictionaryValues = ["username": username, "profileImageUrl": profileImageUrl]
                        let values = [uid: dictionaryValues]
                        
                        Database.database().reference().child("users").updateChildValues(values,withCompletionBlock: { (error, reference) in
                            
                            if let error = error {
                                print("Failed to saver user info into Database:", error)
                                
                                return
                            }
                            
                            print("Siccesfully saved user info into Database")
                            
                        })
                    })
                })
                
            }
            
        })
        self.performSegue(withIdentifier: "singedIn", sender: self)
    }
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

}
