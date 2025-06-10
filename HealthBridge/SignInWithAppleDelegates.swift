//
//  SignInWithAppleDelegates.swift
//  HealthBridge
//
//  Created by kinjal kathiriya  on 6/1/25.
//


import AuthenticationServices
import SwiftUI

class SignInWithAppleDelegates: NSObject {
    private let handleSuccess: (ASAuthorization) -> Void
    private let handleFailure: (Error) -> Void

    init(handleSuccess: @escaping (ASAuthorization) -> Void,
         handleFailure: @escaping (Error) -> Void) {
        self.handleSuccess = handleSuccess
        self.handleFailure = handleFailure
    }
}

extension SignInWithAppleDelegates: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        handleSuccess(authorization)
    }

    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithError error: Error) {
        handleFailure(error)
    }
}

extension SignInWithAppleDelegates: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        // Use the active scene/window (safe way to find the app window)
        return UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first ?? UIWindow()
    }
}
