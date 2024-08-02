//
//  PasswordGenerator.swift
//  PasswordManager
//
//  Created by srisshar on 02/08/24.
//

import Foundation

class PasswordGenerator {
    /// Generates a random password of a specified length.
    /// - Parameter length: The length of the password to generate. Defaults to 12.
    /// - Returns: A randomly generated password as a `String`.
    static func generatePassword(length: Int = 12) -> String {
        // Define the set of characters to use in the password
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+-=[]{}|;':,./<>?"
        
        // Create and return a password by selecting random characters from the set
        return String((0..<length).compactMap { _ in characters.randomElement() })
    }
}
