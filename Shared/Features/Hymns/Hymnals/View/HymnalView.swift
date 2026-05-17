//
//  HymnalView.swift
//  ChristInSong
//
//  Created by Tinashe  on 2020/07/19.
//

import SwiftUI

struct HymnalView: View {
    
    private let COLORS: [String] = ["#4b207f", "#5e3929", "#7f264a", "#2f557f", "#e36520", "#448d21", "#3e8391"]
    
    let book: StoreBook
    var index: Int
    let isPinned: Bool
    let onTogglePin: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    HapticsManager.instance.trigger(.buttonPress)
                    onTogglePin()
                } label: {
                    
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color(hex: COLORS[index % COLORS.count]))
                            .frame(width: 42, height: 42)
                        
                        Image(systemName: isPinned ? "pin.fill" : "plus")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .scaleEffect(isPinned ? 1.0 : 0.9)
                            .rotationEffect(.degrees(isPinned ? 45 : 0))
                            .symbolEffect(.bounce, value: isPinned)
                    }
                }
                .buttonStyle(.plain)
                .animation(.easeInOut(duration: 0.2), value: isPinned)
                
                VStack(alignment: .leading) {
                    Text(book.title)
                        .headLineStyle(selected: book.isSelected)
                    
                    Text(book.language)
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

struct HymnalView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                HymnalView(book: .init(key: "shona", language: "Shona", title: "Shona"), index: 1, isPinned: false, onTogglePin: {})
                    .previewLayout(.sizeThatFits)
                
                HymnalView(book: .init(key: "cis", language: "English", title: "Christ In Song"), index: 1, isPinned: true, onTogglePin: {})
                    .previewLayout(.sizeThatFits)
                
                HymnalView(book: .init(key: "shona-2", language: "Cristu Munzwiyo", title: "Shona"), index: 4, isPinned: false, onTogglePin: {})
                    .previewLayout(.sizeThatFits)
                    .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
                
            }
        }
        .padding()
    }
}
