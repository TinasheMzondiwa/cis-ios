//
//  HymnalView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/19.
//

import SwiftUI

struct OldHymnalView: View {
    
    private let COLORS: [String] = ["#4b207f", "#5e3929", "#7f264a", "#2f557f", "#e36520", "#448d21", "#3e8391"]
    
    var hymnal: HymnalModel
    var index: Int
    
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.init(hex: COLORS[index % COLORS.count]))
                        .frame(width: 42, height: 42, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                    SFSymbol.checkmark
                        .foregroundColor(.white)
                        .opacity(hymnal.selected ? 1 : 0)
                }
                
                VStack(alignment: .leading) {
                    Text(hymnal.title)
                        .headLineStyle(selected: hymnal.selected)
                        
                    Text(hymnal.language)
                        .subHeadLineStyle()
                }.padding(.leading, 16)
                
                Spacer()
            }
            .padding([.bottom], 8)
            .padding([.top], 16)
            
            Divider()
                .padding(.leading, 70)
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

struct OldHymnalView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OldHymnalView(hymnal: HymnalModel(
                id: "",
                title: "Christ In Song",
                language: "English",
                selected: true
            ), index: 1)
            .previewLayout(.sizeThatFits)
            
            OldHymnalView(hymnal: HymnalModel(
                id: "",
                title: "Cristu Munzwiyo",
                language: "Shona",
                selected: false
            ), index: 4)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
            
            OldHymnalView(hymnal: HymnalModel(
                id: "",
                title: "Christ In Song",
                language: "English",
                selected: false
            ), index: 1)
            .previewLayout(.sizeThatFits)
            
            OldHymnalView(hymnal: HymnalModel(
                id: "",
                title: "Cristu Munzwiyo",
                language: "Shona",
                selected: true
            ), index: 4)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
            
        }
    }
}
