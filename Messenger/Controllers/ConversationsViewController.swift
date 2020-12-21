//
//  ViewController.swift
//  Messenger
//
//  Created by 郭丰锐 on 2020/12/21.
//

import UIKit

class ConversationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let isLogin = UserDefaults.standard.bool(forKey: "logged_in")
        if !isLogin {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.navigationBar.backgroundColor = .white
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false) {
            }
        }
    }
}

