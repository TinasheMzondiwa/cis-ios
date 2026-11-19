//
//  TVNumberPadView.swift
//  tvOS
//

import SwiftUI

struct TVNumberPadView: View {
    @Binding var enteredNumber: String
    let onCommit: (Int) -> Void
    
    private let rows: [[KeyType]] = [
        [.digit(1), .digit(2), .digit(3)],
        [.digit(4), .digit(5), .digit(6)],
        [.digit(7), .digit(8), .digit(9)],
        [.clear, .digit(0), .backspace]
    ]
    
    enum KeyType: Hashable {
        case digit(Int)
        case clear
        case backspace
    }
    
    private func handleKey(_ key: KeyType) {
        switch key {
        case .digit(let n):
            if enteredNumber.count < 4 {
                enteredNumber.append("\(n)")
            }
        case .clear:
            enteredNumber = ""
        case .backspace:
            if !enteredNumber.isEmpty {
                enteredNumber.removeLast()
            }
        }
    }
    
    @ViewBuilder
    private func keyLabel(for key: KeyType) -> some View {
        switch key {
        case .digit(let n):
            Text("\(n)")
                .font(TVStyle.uiFont(size: 32, weight: .medium))
                .frame(width: 92, height: 70)
        case .clear:
            Text(LocalizedStringKey("Common.Clear"))
                .font(TVStyle.uiFont(size: 18, weight: .semibold))
                .frame(width: 92, height: 70)
        case .backspace:
            Image(systemName: "delete.backward")
                .font(.system(size: 24, weight: .semibold))
                .frame(width: 92, height: 70)
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Minimalist Number Display
            HStack(spacing: 16) {
                Text(enteredNumber.isEmpty ? "—" : enteredNumber)
                    .font(TVStyle.titleFont(size: 56))
                    .foregroundStyle(enteredNumber.isEmpty ? Color.white.opacity(0.2) : TVStyle.accentGold)
                    .frame(minWidth: 180, minHeight: 76)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.white.opacity(0.06))
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(
                                        enteredNumber.isEmpty ? Color.white.opacity(0.12) : TVStyle.accentGold.opacity(0.5),
                                        lineWidth: 1.5
                                    )
                            )
                    )
                
                if let num = Int(enteredNumber), num > 0 {
                    Button {
                        onCommit(num)
                    } label: {
                        HStack(spacing: 6) {
                            Text(LocalizedStringKey("Common.Go"))
                                .font(TVStyle.uiFont(size: 22, weight: .bold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(TVStyle.accentGold)
                    .foregroundStyle(Color.black)
                }
            }
            .frame(height: 80)
            
            // Keypad Grid with ample focus spacing
            VStack(spacing: 20) {
                ForEach(rows, id: \.self) { row in
                    HStack(spacing: 20) {
                        ForEach(row, id: \.self) { key in
                            Button {
                                handleKey(key)
                            } label: {
                                keyLabel(for: key)
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                }
            }
        }
    }
}
