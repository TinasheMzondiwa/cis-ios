//
//  CheckBoxView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2021/02/27.
//

import SwiftUI

struct CheckBoxView: View {
    
    @Binding var checked: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .trim(from: 0, to: checked ? 1 : 0)
                .stroke(style: StrokeStyle(lineWidth: 2))
                .frame(width: 40, height: 40)
                .foregroundColor(checked ? Color.accentColor : Color(.secondarySystemBackground))
            
            RoundedRectangle(cornerRadius: 10)
                .trim(from: 0, to: 1)
                .fill(checked ? Color.accentColor : Color(.secondarySystemBackground))
                .frame(width: 30, height: 30)
            
            if checked {
                SFSymbol.checkmark
                    .foregroundColor(.white)
            }
        }
        .animation(checked ? .easeIn(duration: 0.6) : .easeIn)
    }
}

struct CheckBoxView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CheckBoxView(checked: .constant(true))
                .previewLayout(.sizeThatFits)
            CheckBoxView(checked: .constant(false))
                .previewLayout(.sizeThatFits)
        }
    }
}
