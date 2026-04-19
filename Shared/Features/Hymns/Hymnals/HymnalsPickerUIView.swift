//
//  HymnalsPickerUIView.swift
//  iOS
//
//  Created by Tinashe Mzondiwa on 2026-04-19.
//

import SwiftUI

struct HymnalsPickerUIView: View {
    
    let book: String
    let books: [StoreBook]
    let onSelect: (StoreBook) -> Void
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var isSheetPresented = false
    @State private var isFullScreenPresented = false
    @Namespace private var namespace
    
    var body: some View {
        Button(action: {
            HapticsManager.instance.trigger(.light)
            
            if horizontalSizeClass == .compact {
                isFullScreenPresented = true
            } else {
                isSheetPresented = true
            }
        }) {
            HStack(alignment: .center) {
                Text(book)
                    .foregroundColor(.primary.opacity(1.0))
                
                Image(systemName: "chevron.compact.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .buttonStyle(.glass)
        .matchedTransitionSource(id: "transition-id", in: namespace)
        .sheet(isPresented: $isSheetPresented) {
            NavigationStack {
                HymnalsView(books: books) { book in
                    isSheetPresented = false
                    onSelect(book)
                } dismissAction: {
                    isSheetPresented = false
                }
                
            }.navigationTransition(.zoom(sourceID: "transition-id", in: namespace))
        }
        .fullScreenCover(isPresented: $isFullScreenPresented) {
            NavigationStack {
                HymnalsView(books: books) { book in
                    isFullScreenPresented = false
                    onSelect(book)
                } dismissAction: {
                    isFullScreenPresented = false
                }
            }.navigationTransition(.zoom(sourceID: "transition-id", in: namespace))
        }
    }
}

#Preview {
    HymnalsPickerUIView(
        book: "Christ In Song",
        books: [],
        onSelect: { book in },
    )
}
