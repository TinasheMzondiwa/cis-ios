//
//  NumberPickerView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2026/04/25.
//

import SwiftUI

struct NumberPickerView: View {
    @Environment(\.dismiss) private var dismiss
    
    let maxNumber: Int
    let onSelect: (Int) -> Void
    
    @State private var enteredString: String = ""
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private var isValid: Bool {
        guard let num = Int(enteredString) else { return false }
        return num >= 1 && num <= maxNumber
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Custom Navigation Bar Header
            ZStack {
                HStack {
                    Button("Cancel") {
                        HapticsManager.instance.trigger(.light)
                        dismiss()
                    }
                    Spacer()
                    Button(action: {
                        if let num = Int(enteredString), isValid {
                            HapticsManager.instance.trigger(.success)
                            onSelect(num)
                            dismiss()
                        }
                    }) {
                        Text("Go")
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                            .font(.body.bold())
                    }
                    .buttonStyle(.glassProminent)
                    .disabled(!isValid)
                }
                
                Text("Go to Hymn")
                    .font(.headline)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            // Display the typed number
            Text(enteredString.isEmpty ? " " : enteredString)
                .font(.system(size: 40, weight: .semibold, design: .rounded))
                .frame(height: 50)
                .foregroundColor(isValid ? .primary : .red)
            
            if !enteredString.isEmpty && !isValid {
                Text("Enter a number between 1 and \(maxNumber)")
                    .font(.caption)
                    .foregroundColor(.red)
            } else {
                Text(" ")
                    .font(.caption)
            }
            
            // Dial pad
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(1...9, id: \.self) { digit in
                    DialButton(text: "\(digit)") {
                        append(digit: "\(digit)")
                        HapticsManager.instance.trigger(.light)
                    }
                }
                
                // Bottom row
                Color.clear // Empty space
                
                DialButton(text: "0") {
                    append(digit: "0")
                    HapticsManager.instance.trigger(.light)
                }
                
                Button(action: {
                    if !enteredString.isEmpty {
                        enteredString.removeLast()
                    }
                    HapticsManager.instance.trigger(.heavy)
                }) {
                    Image(systemName: "delete.left.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.secondary)
                }
                .padding()
                .buttonStyle(.glass)
                .disabled(enteredString.isEmpty)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 20)
            .onChange(of: isValid) { old, new in
                if !new, !enteredString.isEmpty {
                    HapticsManager.instance.trigger(.error)
                }
            }
        }
    }
    
    private func append(digit: String) {
        if enteredString.count < 3 {
            enteredString.append(digit)
            HapticsManager.instance.trigger(.light)
        } else {
            HapticsManager.instance.trigger(.error)
        }
    }
}

struct DialButton: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text(text)
                .font(.system(size: 32, weight: .regular))
                .foregroundColor(.primary)
                .frame(width: 75, height: 75)
                .background(Color.secondary.opacity(0.15))
                .clipShape(Circle())
        }
    }
}

#Preview {
    NumberPickerView(maxNumber: 300) { _ in }
}
