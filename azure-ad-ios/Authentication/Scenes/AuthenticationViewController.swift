//
//  AuthenticationViewController.swift
//  azure-ad-ios
//
//  Created by neda on 22/6/2563 BE.
//  Copyright © 2563 neda. All rights reserved.
//

import Foundation
import UIKit
import MSAL

class AuthenticationViewController: UIViewController {

    var accessToken = String()
    var applicationContext : MSALPublicClientApplication?
    var webViewParamaters : MSALWebviewParameters?
    
    @IBOutlet weak var loggingText: UITextView!
    @IBOutlet weak var signoutButton: UIButton!
    @IBOutlet weak var callGraphButton: UIButton!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    var currentAccount: MSALAccount?

    override func viewDidLoad() {
        do {
            try self.initMSAL()
        } catch let error {
            self.updateLogging(text: "Unable to create Application Context \(error)")
        }
        
        self.usernameLabel.isHidden = false
        self.loadCurrentAccount()
        self.platformViewDidLoadSetup()
    }
    
    func platformViewDidLoadSetup() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appCameToForeGround(notification:)),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadCurrentAccount()
    }
    
    @objc func appCameToForeGround(notification: Notification) {
        self.loadCurrentAccount()
    }
    
    func initMSAL() throws {
        guard let authorityURL = URL(string: ActiveDirectoryConstants.kAuthority) else {
            self.updateLogging(text: "Unable to create authority URL")
            return
        }
        
        let authority = try MSALAADAuthority(url: authorityURL)
        
        let msalConfiguration = MSALPublicClientApplicationConfig(clientId: ActiveDirectoryConstants.kClientID,
                                                                  redirectUri: ActiveDirectoryConstants.kRedirectUri,
                                                                  authority: authority)
        self.applicationContext = try MSALPublicClientApplication(configuration: msalConfiguration)
        self.initWebViewParams()
    }
    
    func initWebViewParams() {
        self.webViewParamaters = MSALWebviewParameters(authPresentationViewController: self)
    }
    
    @IBAction func callGraphAPI(_ sender: UIButton) {
        self.loadCurrentAccount { (account) in
            
            guard let currentAccount = account else {
                
                // We check to see if we have a current logged in account.
                // If we don't, then we need to sign someone in.
                self.acquireTokenInteractively()
                return
            }
            
            self.acquireTokenSilently(currentAccount)
        }
    }
    
    /**
     This action will invoke the remove account APIs to clear the token cache
     to sign out a user from this application.
     */
    @IBAction func signout(_ sender: UIButton) {
        guard let applicationContext = self.applicationContext else { return }
        guard let account = self.currentAccount else { return }
        
        do {
            /**
             Removes all tokens from the cache for this application for the provided account
             - account:    The account to remove from the cache
             */
            let signoutParameters = MSALSignoutParameters(webviewParameters: self.webViewParamaters!)
            signoutParameters.signoutFromBrowser = false
            
            applicationContext.signout(with: account, signoutParameters: signoutParameters, completionBlock: {(success, error) in
                
                if let error = error {
                    self.updateLogging(text: "Couldn't sign out account with error: \(error)")
                    return
                }
                
                self.updateLogging(text: "Sign out completed successfully")
                self.accessToken = ""
                self.updateCurrentAccount(account: nil)
            })
        }
    }
    
    @IBAction func getDeviceMode(_ sender: UIButton) {
        if #available(iOS 13.0, *) {
            self.applicationContext?.getDeviceInformation(with: nil, completionBlock: { (deviceInformation, error) in
                
                guard let deviceInfo = deviceInformation else {
                    self.updateLogging(text: "Device info not returned. Error: \(String(describing: error))")
                    return
                }
                
                let isSharedDevice = deviceInfo.deviceMode == .shared
                let modeString = isSharedDevice ? "shared" : "private"
                self.updateLogging(text: "Received device info. Device is in the \(modeString) mode.")
            })
        } else {
            self.updateLogging(text: "Running on older iOS. GetDeviceInformation API is unavailable.")
        }
    }
}
