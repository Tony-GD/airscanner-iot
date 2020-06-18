//
//  Auth.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 18.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn

struct Authentication {
    static func signOut() {
        LocalStorage.shared.user = nil
        try? Auth.auth().signOut()
        MapDevicesStorage.shared.unsubscribeFormUserSpecifcInfo()
    }
    
    static func signIn(with credential: AuthCredential, user: GIDGoogleUser) {
        Auth.auth().signIn(with: credential) { (authResult, error) in
            guard let fbUser = authResult?.user else { return }
            fbUser.getIDTokenForcingRefresh(true) { idToken, error in
                guard let token = idToken else { return }
                var photoURL: URL? = nil
                if user.profile.hasImage {
                    photoURL = user.profile.imageURL(withDimension: UInt(round(UIScreen.main.scale * 60.0)))
                }
                LocalStorage.shared.user = User(id: fbUser.uid,
                                                idToken: token,
                                                givenName: user.profile.givenName,
                                                familyName: user.profile.familyName,
                                                email: user.profile.email,
                                                photoURL: photoURL)
                MapDevicesStorage.shared.subscribeForUserSpecificInfo()
            }
        }
    }
    
    static func refreshToken() {
        Auth.auth().currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            guard let token = idToken else { return }
            LocalStorage.shared.user?.idToken = token
        }
    }
}
