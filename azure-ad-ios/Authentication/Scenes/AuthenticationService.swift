//
//  AuthenticationService.swift
//  azure-ad-ios
//
//  Created by neda on 22/6/2563 BE.
//  Copyright © 2563 neda. All rights reserved.
//

import UIKit

class AuthenticationService {

    func display() -> AuthenticationViewController {
        let storyboard = UIStoryboard(name: "Authentication", bundle: .main)
        guard let authenticationVC = storyboard.instantiateViewController(withIdentifier: "AuthenticationVC") as? AuthenticationViewController else {  fatalError("Invalid view type")
        }
        authenticationVC.modalPresentationStyle = .fullScreen
        return authenticationVC
    }
}
