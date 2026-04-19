//
//  SwiftUi+View.swift
//  iOS
//
//  Created by Tinashe Mzondiwa on 2026-04-19.
//

import SwiftUI

extension View {
    func adaptiveSheet<Content: View>(isPresent: Binding<Bool>, @ViewBuilder sheetContent: () -> Content) -> some View {
        modifier(AdaptiveSheetModifier(isPresented: isPresent, sheetContent))
    }
}

struct AdaptiveSheetModifier<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    var sheetContent: SheetContent
    
    @State private var detentHeight: CGFloat = 300 // safe default
    
    init(isPresented: Binding<Bool>, @ViewBuilder _ content: () -> SheetContent) {
        _isPresented = isPresented
        sheetContent = content()
    }
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                sheetContent
                    .background(
                        GeometryReader { proxy in
                            Color.clear
                                .onAppear {
                                    updateHeight(proxy.size.height)
                                }
                                .onChange(of: proxy.size.height) { _, newHeight in
                                    updateHeight(newHeight)
                                }
                        }
                    )
                    .presentationDetents([.height(detentHeight)])
                    .presentationDragIndicator(.visible)
            }
    }
    
    private func updateHeight(_ newHeight: CGFloat) {
        // Prevent 0 or absurd values
        let safeHeight = max(newHeight, 100)
        if abs(detentHeight - safeHeight) > 1 {
            detentHeight = safeHeight
        }
    }
}

