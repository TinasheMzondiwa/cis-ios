import SwiftUI

struct WhatsNewView: View {
    @Binding var isPresented: Bool
    var navigateToSupport: () -> Void
    
    let items: [WhatsNewItem]
    
    @State private var isVisible = false
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 0) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 40, weight: .light))
                        .foregroundColor(.accentColor)
                        .padding(.top, 40)
                    
                    VStack {
                        Text(LocalizedStringKey("WhatsNew.Title"))
                            .font(.largeTitle)
                            .bold()
                            
                        Text(LocalizedStringKey("WhatsNew.Desc"))
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                    .multilineTextAlignment(.center)
                    .padding(.top, 4)
                    .padding(.bottom, 40)
                    .padding(.horizontal)
                    .fontDesign(.rounded)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                            HStack(alignment: .top, spacing: 20) {
                                Image(systemName: item.iconName)
                                    .font(.system(size: 20))
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(.accentColor)
                                    .frame(width: 24, height: 24, alignment: .center)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.title)
                                        .font(.headline)
                                    
                                    Text(item.description)
                                        .font(.subheadline)
                                        .foregroundColor(Color.secondary.opacity(0.8))
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                            .fontDesign(.rounded)
                            .opacity(isVisible ? 1 : 0)
                            .offset(y: isVisible ? 0 : 20)
                            .animation(
                                .easeOut(duration: 0.5).delay(Double(index) * 0.1),
                                value: isVisible
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                    .onAppear {
                        isVisible = true
                    }
                }
            }
            
            VStack(spacing: 0) {
                Divider()
                
                VStack(spacing: 16) {
                    Button(action: {
                        isPresented = false
                    }) {
                        Text(LocalizedStringKey("WhatsNew.Continue"))
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .cornerRadius(30)
                    }
                    .buttonStyle(PressableButtonStyle())
                    
                    Button(action: {
                        isPresented = false
                        navigateToSupport()
                    }) {
                        Text(LocalizedStringKey("Support.Promo.Title"))
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(.accentColor)
                    }
                }
                .padding(24)
                .padding(.bottom, 8)
                .fontDesign(.rounded)
            }
            .background(Color(UIColor.systemBackground))
        }
    }
}

struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct WhatsNewView_Previews: PreviewProvider {
    static var previews: some View {
        WhatsNewView(isPresented: .constant(true), navigateToSupport: {}, items: [
            WhatsNewItem(title: "Redesigned UI", description: "We've updated the look and feel of the app to be more modern and intuitive.", iconName: "sparkles"),
            WhatsNewItem(title: "Support This App", description: "You can now support the development of Christ In Song directly from the new Support tab!", iconName: "heart.fill")
        ])
    }
}
