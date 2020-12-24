//
//  ViewController.swift
//  Messenger
//
//  Created by 郭丰锐 on 2020/12/21.
//

import UIKit
import FirebaseAuth
class ConversationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
//        DatabaseManager.shared.test()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
    }
    
    private func validateAuth() -> Void {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.navigationBar.backgroundColor = .white
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false) {
            }
        }
    }
}

