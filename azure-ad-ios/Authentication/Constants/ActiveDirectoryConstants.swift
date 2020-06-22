//
//  ADConstants.swift
//  azure-ad-ios
//
//  Created by neda on 22/6/2563 BE.
//  Copyright © 2563 neda. All rights reserved.
//

struct ActiveDirectoryConstants {
    // Update the below to your client ID you received in the portal. The below is for running the demo only
    static let kClientID = "xxxx"
    static let kGraphEndpoint = "https://graph.microsoft.com/"
    static let kAuthority = "https://login.microsoftonline.com/xxxx"
    static let kRedirectUri = "msauth.cleancode.sample.azure-ad-ios://auth"
    
    static let kScopes: [String] = ["user.read"]
}
