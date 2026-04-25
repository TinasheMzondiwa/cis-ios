import Foundation

struct WhatsNewItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let description: String
    let iconName: String
}
