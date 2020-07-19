//
//  HymnalView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/19.
//

import SwiftUI

struct HymnalView: View {
    
    private let COLORS: [String] = ["#4b207f", "#5e3929", "#7f264a", "#2f557f", "#e36520", "#448d21", "#3e8391"]
    
    var hymnal: Hymnal
    var index: Int
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 12)
                .frame(width: 48, height: 48, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .foregroundColor(Color.init(hex: COLORS[index % COLORS.count]))
            
            VStack(alignment: .leading) {
                Text(hymnal.title)
                    .font(/*@START_MENU_TOKEN@*/.headline/*@END_MENU_TOKEN@*/)
                Text(hymnal.language)
                    .font(.subheadline)
            }.padding(.leading, 16)
            
            Spacer()
        }
    }
    
    func getColor() -> Color {
        if let random = COLORS.randomElement() {
            return Color.init(hex: random)
        } else {
            return Color.accentColor
        }
    }
}

struct HymnalView_Previews: PreviewProvider {
    static var previews: some View {
        HymnalView(hymnal: Hymnal(
            key: "",
            title: "Christ In Song",
            language: "English"
        ), index: 1)
        .previewLayout(.fixed(width: 300, height: 70))
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
