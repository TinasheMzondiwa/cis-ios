//
//  TextSettingsView.swift
//  iOS
//
//  Created by Tinashe Mzondiwa on 2026-04-19.
//

import SwiftUI

struct TextSettingsView: View {
    
    @AppStorage("hymnalFontSize") private var fontSize: Double = 22.0
    @AppStorage("hymnalTypeface") private var selectedFontRaw: String = AppTypeface.defaultTypeface.rawValue
    
    var body: some View {
        let typeface = AppTypeface(rawValue: selectedFontRaw) ?? .defaultTypeface
        
        VStack(alignment: .leading, spacing: 20, ) {
            
            Spacer()
            
            Section(header: Text(LocalizedStringKey("Typeface"))
                .font(.footnote.weight(.semibold))
                .foregroundColor(.primary))  {
                Menu {
                    Picker("Selection", selection: $selectedFontRaw) {
                        ForEach(AppTypeface.allCases, id: \.rawValue) { type in
                            // Apply the actual font to the menu item for preview
                            Text(type.rawValue)
                                .font(type.font(size: 18))
                                .tag(type.rawValue)
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedFontRaw)
                            .font(typeface.font(size: 20))
                        Spacer()
                        SFSymbol.chevronRight.font(.caption.bold())
                    }
                    .foregroundColor(.primary)
                    .padding()
                    .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
            }
                .padding(.top)
            
            Divider().padding()
            
            Section(header: Text(LocalizedStringKey("Text Size"))
                .font(.footnote.weight(.semibold))
                .foregroundColor(.primary)) {
                    
                    HStack {
                        SFSymbol.testFormatSmaller
                        Slider(value: $fontSize, in: 12...40)
                        SFSymbol.testFormatLarger
                    }
            }
            
            Spacer()
            
        }
        .padding(20)
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    TextSettingsView()
}

