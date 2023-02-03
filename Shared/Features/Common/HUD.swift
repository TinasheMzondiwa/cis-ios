//
//  HUD.swift
//  iOS
//
//  Created by Tinashe  on 2021/03/13.
//
import SwiftUI

struct HUD<Content: View>: View {
    
   private let state: AlertState?
   private let content: Content
    
    init(state: AlertState?, content: Content) {
        self.state = state
        self.content = content
    }
    
    var body: some View {
        content
            .padding(.horizontal, 12)
            .padding(16)
            .background(
                Capsule()
                    .foregroundColor(getColor())
                    .shadow(color: Color(.black).opacity(0.16), radius: 12, x: 0, y: 5)
            )
    }
    
    private func getColor() -> Color {
        switch state {
        case .success:
            return .green
        case .error:
            return .red
        case .warning:
            return .orange
        default:
            return Color(.secondarySystemBackground)
        }
    }
}

extension View {
    func hud<Content: View>(
        state: AlertState?,
        isPresented: Binding<Bool>,
        @ViewBuilder content: () -> Content
    ) -> some View {
        ZStack(alignment: .top) {
            self
            
            if isPresented.wrappedValue {
                HUD(state: state, content: content())
                    .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                isPresented.wrappedValue = false
                            }
                        }
                    }
                    .zIndex(1)
            }
        }
    }
}
