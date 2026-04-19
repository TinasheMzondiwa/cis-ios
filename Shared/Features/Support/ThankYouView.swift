//
//  ThankYouView.swift
//  iOS
//
//  Created by Tinashe Mzondiwa on 2026-04-19.
//

import SwiftUI

struct ThankYouView: View {
    let productID: String?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            
            Spacer()
            
            // Icon
            Text("🙏")
                .font(.system(size: 64))
            
            // Title
            Text("Thank You!")
                .font(.title.bold())
            
            // Message
            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            // Button
            Button("Continue") {
                dismiss()
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(14)
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }

    private var message: String {
        switch productID {
        case "tip_small":
            return "Your support means a lot and helps keep this app running."
        case "tip_medium":
            return "Thank you for supporting the app! You're helping keep it free for everyone."
        case "tip_large":
            return "Your generosity truly makes a difference. Thank you for helping this app grow."
        case "tip_xlarge":
            return "Wow — thank you for your incredible support! This really helps sustain the app."
        default:
            return "Thank you for your support. It truly means a lot."
        }
    }
}

#Preview {
    ThankYouView(productID: "tip_xlarge")
}
