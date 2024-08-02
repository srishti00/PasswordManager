//
//  PasswordStrengthView.swift
//  PasswordManager
//
//  Created by srisshar on 02/08/24.
//

import SwiftUI

struct PasswordStrengthView: View {
    @Binding var password: String

    var body: some View {
        VStack(alignment: .leading) {
            // Display the strength label based on the password's strength
            Text(strengthLabel)
                .font(.caption)
                .foregroundColor(labelColor)
            
            HStack(spacing: 4) {
                // Display circles representing the password strength
                ForEach(0..<5) { index in
                    Circle()
                        .fill(self.color(for: index))
                        .frame(width: 8, height: 8)
                }
            }
        }
    }

    // Determine the label for the password strength
    private var strengthLabel: String {
        switch passwordStrength(password) {
        case 1:
            return "Weak"
        case 2:
            return "Fair"
        case 3:
            return "Good"
        case 4:
            return "Strong"
        case 5:
            return "Very Strong"
        default:
            return "Weak"
        }
    }

    // Determine the color of the strength label based on password strength
    private var labelColor: Color {
        switch passwordStrength(password) {
        case 1:
            return .red
        case 2:
            return .yellow
        case 3:
            return .orange
        case 4:
            return .blue
        case 5:
            return .green
        default:
            return .red
        }
    }

    // Determine the color of each circle based on the password strength
    private func color(for index: Int) -> Color {
        let strength = passwordStrength(password)
        return index < strength ? colorForStrength(strength) : .gray
    }

    // Return the color associated with a specific strength level
    private func colorForStrength(_ strength: Int) -> Color {
        switch strength {
        case 1:
            return .red
        case 2:
            return .yellow
        case 3:
            return .orange
        case 4:
            return .blue
        case 5:
            return .green
        default:
            return .red
        }
    }

    // Calculate the strength of the given password based on its composition and length
    private func passwordStrength(_ password: String) -> Int {
        let hasUppercase = password.rangeOfCharacter(from: .uppercaseLetters) != nil
        let hasLowercase = password.rangeOfCharacter(from: .lowercaseLetters) != nil
        let hasDigits = password.rangeOfCharacter(from: .decimalDigits) != nil
        let hasSymbols = password.rangeOfCharacter(from: .init(charactersIn: "!@#$%^&*()_+-=[]{}|;:'\",.<>?/")) != nil
        
        let length = password.count

        // Determine the strength level based on character types and length
        if length > 8 {
            if hasUppercase && hasLowercase && hasDigits && hasSymbols {
                return 5
            } else if (hasUppercase || hasLowercase) && hasDigits && hasSymbols {
                return 4
            } else if (hasUppercase || hasLowercase) && hasDigits {
                return 3
            } else if hasDigits || (hasUppercase || hasLowercase) {
                return 2
            }
        } else {
            if (hasUppercase || hasLowercase) && hasDigits && hasSymbols {
                return 3
            } else if (hasUppercase || hasLowercase) && hasDigits {
                return 2
            } else if hasDigits || (hasUppercase || hasLowercase) {
                return 1
            }
        }
        return 1
    }
}

