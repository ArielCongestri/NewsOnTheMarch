//
//  testViewController.swift
//  Proyecto Integrador
//
//  Created by Familia Congestri on 25/7/18.
//  Copyright © 2018 Digital House. All rights reserved.
//

import UIKit
import Firebase

class LogInStoryboarViewController: UIViewController {
    
    @IBOutlet weak var Stack: UIStackView!
    @IBOutlet weak var singUpButton: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Auth.auth().currentUser?.displayName)

        image.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        setupLogoImage()
        
        
        
        setupEmailTF()
        setupPassTF()
        setupSingUp()
        setupLoginButton()
        singUpButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        setupBackgroundImage()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            print("me jui")
            performSegue(withIdentifier: "logedIn", sender: self)
        }
    }

    func setupLogoImage(){
        let imageView = UIImageView(image: #imageLiteral(resourceName: "notmLogo"))
        image.image = imageView.image
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 140 / 2
        image.clipsToBounds = true
    }
    
    func setupLoginButton(){
        loginButton.setTitle("Login", for: .normal)
        loginButton.tintColor = UIColor.darkGray
        loginButton.backgroundColor = UIColor(red: 1, green: 218/255, blue: 68/255, alpha: 0.6)
        loginButton.layer.cornerRadius = 5
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        loginButton.setTitleColor(.white, for: .normal)
    }
    
    func setupEmailTF(){
        emailTextField.placeholder = "Email"
        emailTextField.backgroundColor = UIColor(white: 1, alpha: 0.95)
        emailTextField.borderStyle = .roundedRect
        emailTextField.font = UIFont.systemFont(ofSize: 14)
		emailTextField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
    }
	
    func setupPassTF(){
        passTextField.placeholder = "Password"
        passTextField.isSecureTextEntry = true
        passTextField.backgroundColor = UIColor(white: 1, alpha: 0.95)
        passTextField.borderStyle = .roundedRect
        passTextField.font = UIFont.systemFont(ofSize: 14)
		passTextField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
    }
	
	@objc fileprivate func handleTextInputChange() {
		let isFormValid = emailTextField.text?.isEmpty == false && passTextField.text?.isEmpty == false
		
		if isFormValid {
			loginButton.isEnabled = true
			loginButton.backgroundColor = UIColor(red: 1, green: 218/255, blue: 68/255, alpha: 1)
		} else {
			loginButton.isEnabled = false
			loginButton.backgroundColor = UIColor(red: 1, green: 218/255, blue: 68/255, alpha: 0.6)
		}
	}
	
    func setupSingUp(){
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.white])
        
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor(red: 1, green: 218/255, blue: 68/255, alpha: 1)
            ]))
        singUpButton.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    fileprivate func setupBackgroundImage() {
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "loginBackground") ).withAlphaComponent(0.8)
    }
    
    @IBAction func EditingDidChange(_ sender: Any) {
        let isFormValid = emailTextField.text?.isEmpty == false && passTextField.text?.isEmpty == false
        
        if isFormValid {

            loginButton.backgroundColor = UIColor(red: 1, green: 218/255, blue: 68/255, alpha: 1)
        } else {

            loginButton.backgroundColor = UIColor(red: 1, green: 218/255, blue: 68/255, alpha: 0.6)
        }
    }
    
	
    @IBAction func logInButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text else { return }
        guard let password = passTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, err) in
            
            if let err = err {
                print("Failed to sign in with email:", err)
                return
            }
            
            print("Successfully logged back in with user:", user?.user.uid ?? "")
            
            self.performSegue(withIdentifier: "logedIn", sender: self)
            self.emailTextField.text = ""
            self.passTextField.text = ""

            
            
        })
    }
    
    fileprivate func checkUserLogin() {
        
    }
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

}
