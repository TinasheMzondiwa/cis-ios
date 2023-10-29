//
//  FocusTextField.swift
//  iOS
//
//  Created by Tinashe  on 2021/02/25.
//

import SwiftUI

struct FocusTextField: View {
    @State private var enabled: Bool = false
    @Binding var text: String
    
    var hint: String
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TextField(hint, text: $text, onEditingChanged: { (editingChanged) in
                withAnimation {
                    enabled = editingChanged
                }
            })
            .lineLimit(1)
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8, corners: [.topLeft, .topRight])
            
            Capsule()
                .fill(Color.accentColor)
                .frame(height: 2)
                .cornerRadius(0)
                .opacity(enabled ? 1 : 0)
        }
        .shadow(radius: enabled ? 4 : 0)
    }
}

struct FocusTextField_Previews: PreviewProvider {
    static var previews: some View {
        FocusTextField(text: .constant(""), hint: "Title")
    }
}
