//
//  LoginViewController.swift
//  Messenger
//
//  Created by 郭丰锐 on 2020/12/21.
//

import UIKit
import Firebase
import FBSDKLoginKit
class LoginViewController: UIViewController {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imgView: UIImageView = {
        let imagView = UIImageView()
        imagView.image = UIImage(named: "logo")
        imagView.contentMode = .scaleAspectFit
        return imagView
    }()
    private let emailField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .continue
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 12
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.placeholder = "Email Address..."
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textField.leftViewMode = .always
        textField.backgroundColor = .white
        return textField
    }()
    
    private let passwordField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 12
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.placeholder = "Password..."
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textField.leftViewMode = .always
        textField.backgroundColor = .white
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let loginBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .link
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let faceBookloginButton: FBLoginButton = {
        let button = FBLoginButton()
        button.permissions = ["email,public_profile"]
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapRegister))
        emailField.delegate = self
        faceBookloginButton.delegate = self
        passwordField.delegate = self
        view.addSubview(scrollView)
        scrollView.addSubview(imgView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginBtn)
        scrollView.addSubview(faceBookloginButton)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width / 3
        imgView.frame = CGRect(x: (scrollView.width - size) / 2,
                               y: 20,
                               width: size,
                               height: size)
        emailField.frame = CGRect(x: 30,
                                  y: imgView.bottom - 10,
                                  width: scrollView.width - 60,
                                  height: 52)
        passwordField.frame = CGRect(x: 30,
                                  y: emailField.bottom + 10,
                                  width: scrollView.width - 60,
                                  height: 52)
        loginBtn.frame = CGRect(x: 30,
                                y: passwordField.bottom + 10,
                                width: scrollView.width - 60,
                                height: 52)
        faceBookloginButton.frame = CGRect(x: 30,
                                y: loginBtn.bottom + 10,
                                width: scrollView.width - 60,
                                height: 52)
//        loginButton.center = scrollView.center
//        loginButton.frame.origin.y = loginBtn.bottom + 20
    }
    
    @objc private func loginButtonTapped() -> Void {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        guard let email = emailField.text, let password = passwordField.text, !email.isEmpty, !password.isEmpty, password.count >= 6 else {
            alertUserLoginError()
            return
        }
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] (authResult, error) in
            guard let strongSelf = self else {
                return
            }
            guard let result = authResult, error == nil else {
                print("Faild to log in user with email: \(email)")
                return
            }
            let user = result.user
            print("Logged In User: \(user)")
            strongSelf.navigationController?.dismiss(animated: true) {
            }
        }
    }
    
    func alertUserLoginError() -> Void {
        let alert = UIAlertController(title: "Woops",
                                      message: "Please enter all infomation to login",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true) {
        }
    }
    
    @objc func didTapRegister() -> Void {
        let registerVC = RegisterViewController()
        registerVC.title = "Create Account";
        navigationController?.pushViewController(registerVC, animated: true)
    }
    

}
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            loginButtonTapped()
        }
        return true
    }
}

extension LoginViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            print("User faild to log in with facebook")
            return
        }
        
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                         parameters: ["fields": "email, name"],
                                                         tokenString: token,
                                                         version: nil,
                                                         httpMethod: .get)
        facebookRequest.start { ( _, result, error) in
            guard let result = result as? [String: Any], error == nil else {
                print("Failed to make facenook graph request")
                return
            }
            print("\(result)")
            guard let userName = result["name"] as? String,
                  let email = result["email"] as? String else {
                print("Failed to get email and name from fb result")
                return
            }
            let nameComeponents = userName.components(separatedBy: " ")
            
            guard nameComeponents.count == 2 else {
                return
            }
            let firstName = nameComeponents[0]
            let lastName = nameComeponents[1]
            
            DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstName, lastName: lastName, email: email))
            
            FirebaseAuth.Auth.auth().signIn(withCustomToken: token) {  [weak self] (aulthResult, error) in
                guard let strongSelf = self else {
                    return
                }
                guard aulthResult != nil, error == nil else {
                    if let error = error {
                        print("log in failed with token\(error)")
                    }
                    
                    return
                }
                strongSelf.navigationController?.dismiss(animated: true) {
                }
            }
        }
    
//        let credential = FacebookAuthProvider.credential(withAccessToken: token)
        
       
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    
    
}
