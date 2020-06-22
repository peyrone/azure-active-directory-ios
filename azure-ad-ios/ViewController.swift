//
//  ViewController.swift
//  azure-ad-ios
//
//  Created by neda on 22/6/2563 BE.
//  Copyright © 2563 neda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let authenticationService = AuthenticationService()

    override func viewDidAppear(_ animated: Bool) {
        // Do any additional setup after loading the view.
        
        let authenticationVC = authenticationService.display()
        present(authenticationVC, animated: animated)
    }
}
