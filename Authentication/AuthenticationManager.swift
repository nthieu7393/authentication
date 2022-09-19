//
//  AuthenticationManager.swift
//  test_keychain
//
//  Created by hieu nguyen on 18/09/2022.
//

import Foundation

open class AuthenticationManager {
    
    init() {}
    
    public func googleSignIn(onCompletion: (_ result: Result<String, AuthenticationError>) -> Void) {
        onCompletion(.success("google sign in thanh cong"))
    }
    
    open func appleSignIn(onCompletion: (_ result: Result<String, AuthenticationError>) -> Void) {
        onCompletion(.success("apple sign in thanh cong"))
    }
    
    public func systemSignIn(onCompletion: (_ result: Result<String, AuthenticationError>) -> Void) {
        onCompletion(.failure(AuthenticationError.systemLogin(message: "fail roi kia")))
    }
}

public enum AuthenticationError: Error {
    case googleLogin
    case appleLogin
    case systemLogin(message: String)
}
