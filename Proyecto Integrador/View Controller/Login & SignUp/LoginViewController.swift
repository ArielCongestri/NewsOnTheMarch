//
//  LoginViewController.swift
//  Proyecto Integrador
//
//  Created by Victor Chang on 20/07/2018.
//  Copyright © 2018 Digital House. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
	
	let logoImageView: UIImageView = {
		let imageView = UIImageView(image: #imageLiteral(resourceName: "notmLogo"))
		imageView.contentMode = .scaleAspectFill
		imageView.layer.cornerRadius = 140 / 2
		imageView.clipsToBounds = true

		return imageView
	}()
	
	let emailTextField: UITextField = {
		let tf = UITextField()
		tf.placeholder = "Email"
		tf.backgroundColor = UIColor(white: 1, alpha: 0.95)
		tf.borderStyle = .roundedRect
		tf.font = UIFont.systemFont(ofSize: 14)
		
		tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
		
		return tf
	}()
	
	let passwordTextField: UITextField = {
		let tf = UITextField()
		tf.placeholder = "Password"
		tf.isSecureTextEntry = true
		tf.backgroundColor = UIColor(white: 1, alpha: 0.95)
		tf.borderStyle = .roundedRect
		tf.font = UIFont.systemFont(ofSize: 14)
		tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
		return tf
	}()
	
	@objc func handleTextInputChange() {
		let isFormValid = emailTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false
		
		if isFormValid {
			loginButton.isEnabled = true
			loginButton.backgroundColor = UIColor(red: 1, green: 218/255, blue: 68/255, alpha: 1)
		} else {
			loginButton.isEnabled = false
			loginButton.backgroundColor = UIColor(red: 1, green: 218/255, blue: 68/255, alpha: 0.6)
		}
	}
	
	let loginButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Login", for: .normal)
		button.tintColor = UIColor.darkGray
		button.backgroundColor = UIColor(red: 1, green: 218/255, blue: 68/255, alpha: 0.6)
		
		button.layer.cornerRadius = 5
		button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
		button.setTitleColor(.white, for: .normal)
		
		button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
		
		button.isEnabled = false
		
		return button
	}()
	
	@objc func handleLogin() {
		guard let email = emailTextField.text else { return }
		guard let password = passwordTextField.text else { return }
		
		Auth.auth().signIn(withEmail: email, password: password, completion: { (user, err) in
			
			if let err = err {
				print("Failed to sign in with email:", err)
				return
			}
			
			print("Successfully logged back in with user:", user?.user.uid ?? "")
			
			self.performSegue(withIdentifier: "isLogged", sender: self)
			self.emailTextField.text = ""
			self.passwordTextField.text = ""
//			self.dismiss(animated: true, completion: nil)

			
		})
	}
	
	let dontHaveAccountButton: UIButton = {
		let button = UIButton(type: .system)
		
		let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.black])
		
		attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor(red: 1, green: 218/255, blue: 68/255, alpha: 1)
			]))
		
		button.setAttributedTitle(attributedTitle, for: .normal)
		
		button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
		return button
	}()
	
	@objc func handleShowSignUp() {
//		navigationController?.pushViewController(signUpViewController, animated: true)
//		performSegue(withIdentifier: "isNotLogged", sender: self)
		
		let signUpViewController = SignUpViewController()
		self.present(signUpViewController, animated: true, completion: nil)
		
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		super.viewDidLoad()
		self.hideKeyboardWhenTappedAround() 
		view.addSubview(logoImageView)
		logoImageView.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
		logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		
		navigationController?.isNavigationBarHidden = true
		
		view.backgroundColor = .white
		
		view.addSubview(dontHaveAccountButton)
		dontHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
		
		setupInputFields()
		setupBackgroundImage()
		checkUserLogin()
		//UserDefaults.standard.set(true, forKey: "firtsTime")

	}
	
	override func viewDidAppear(_ animated: Bool) {
	}
	
	fileprivate func checkUserLogin() {
		DispatchQueue.main.async {
			if Auth.auth().currentUser != nil {
                
				self.performSegue(withIdentifier: "isLogged", sender: self)
			} else {
				
			}

		}
    }
	
	fileprivate func setupBackgroundImage() {
		self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "loginBackground") )
	}
	
	fileprivate func setupInputFields() {
		let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
		
		stackView.axis = .vertical
		stackView.spacing = 10
		stackView.distribution = .fillEqually
		
		view.addSubview(stackView)
		stackView.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 140)
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if "isLogged" == segue.identifier {
		}
	}
}
