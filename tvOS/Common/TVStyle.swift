//
//  TVStyle.swift
//  tvOS
//

import SwiftUI

enum TVStyle {
    // Sizing constants for 10-foot viewing experience
    static let horizontalPadding: CGFloat = 80
    static let verticalPadding: CGFloat = 40
    static let cardCornerRadius: CGFloat = 18
    static let pillCornerRadius: CGFloat = 12
    
    // Ambient Worship Colors
    static let accent = Color.white
    static let accentGold = Color.white
    static let deepBackground = Color(red: 10/255, green: 14/255, blue: 24/255)
    static let cardBackground = Color.white.opacity(0.06)
    static let cardBorder = Color.white.opacity(0.12)
    static let chorusBackground = Color.white.opacity(0.12)
    static let chorusBorder = Color.white.opacity(0.30)
    
    // Typography helpers using project's EB Garamond or system serif/rounded fonts
    static func titleFont(size: CGFloat = 48) -> Font {
        AppTypeface.garamond.font(size: Double(size), weight: .bold)
    }
    
    static func verseFont(size: CGFloat = 38) -> Font {
        AppTypeface.garamond.font(size: Double(size), weight: .regular)
    }
    
    static func chorusFont(size: CGFloat = 38) -> Font {
        AppTypeface.garamond.font(size: Double(size), weight: .regular, italic: true)
    }
    
    static func uiFont(size: CGFloat = 24, weight: Font.Weight = .medium) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }
}

// MARK: - Ambient Background Themes
enum TVTheme: String, CaseIterable, Identifiable {
    case slate = "slate"
    case pine = "pine"
    case black = "black"
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .slate:
            return "Midnight Slate"
        case .pine:
            return "Sacred Pine & Bronze"
        case .black:
            return "Pure Black"
        }
    }
    
    var subtitle: String {
        switch self {
        case .slate:
            return "Subtle atmospheric navy and slate glow"
        case .pine:
            return "Downtoned evergreen with warm bronze tint"
        case .black:
            return "OLED true black for minimal distraction"
        }
    }
}

// MARK: - Ambient Apple-Style Fluid Mesh Background
struct TVAmbientBackground: View {
    @AppStorage("tv_background_theme") private var themeRaw: String = TVTheme.pine.rawValue
    @State private var animate = false
    
    private var currentTheme: TVTheme {
        TVTheme(rawValue: themeRaw) ?? .pine
    }
    
    var body: some View {
        ZStack {
            switch currentTheme {
            case .slate:
                slateMesh
            case .pine:
                pineMesh
            case .black:
                Color.black.ignoresSafeArea()
            }
        }
        .animation(.easeInOut(duration: 0.6), value: themeRaw)
        .onAppear {
            withAnimation(.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
    
    @ViewBuilder
    private var slateMesh: some View {
        ZStack {
            // Base deep navy / obsidian
            Color(red: 6/255, green: 9/255, blue: 17/255)
                .ignoresSafeArea()
            
            GeometryReader { proxy in
                let w = proxy.size.width
                let h = proxy.size.height
                
                ZStack {
                    // 1. Top-Left: Muted Dusky Rose
                    Circle()
                        .fill(Color(red: 135/255, green: 65/255, blue: 82/255).opacity(0.28))
                        .frame(width: w * 0.58, height: w * 0.58)
                        .position(x: animate ? w * 0.22 : w * 0.17, y: animate ? h * 0.24 : h * 0.18)
                        .blur(radius: 110)
                    
                    // 2. Top-Center: Muted Slate Azure
                    Ellipse()
                        .fill(Color(red: 20/255, green: 82/255, blue: 145/255).opacity(0.38))
                        .frame(width: w * 0.68, height: h * 0.72)
                        .position(x: animate ? w * 0.53 : w * 0.47, y: animate ? h * 0.28 : h * 0.33)
                        .blur(radius: 120)
                    
                    // 3. Top-Right: Pale Slate Sky
                    Circle()
                        .fill(Color(red: 90/255, green: 125/255, blue: 160/255).opacity(0.20))
                        .frame(width: w * 0.52, height: w * 0.52)
                        .position(x: animate ? w * 0.83 : w * 0.77, y: animate ? h * 0.19 : h * 0.25)
                        .blur(radius: 110)
                    
                    // 4. Center-Lower: Deep Muted Cerulean
                    Ellipse()
                        .fill(Color(red: 22/255, green: 70/255, blue: 125/255).opacity(0.32))
                        .frame(width: w * 0.78, height: h * 0.62)
                        .position(x: animate ? w * 0.47 : w * 0.53, y: animate ? h * 0.68 : h * 0.62)
                        .blur(radius: 130)
                }
                .drawingGroup()
            }
            .ignoresSafeArea()
            
            // Atmospheric Vignette & Contrast Scrim
            LinearGradient(
                stops: [
                    .init(color: Color.black.opacity(0.35), location: 0.0),
                    .init(color: Color.clear, location: 0.32),
                    .init(color: Color.black.opacity(0.60), location: 0.75),
                    .init(color: Color.black.opacity(0.88), location: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    private var pineMesh: some View {
        ZStack {
            // Base deep dark forest shade
            Color(red: 4/255, green: 9/255, blue: 6/255)
                .ignoresSafeArea()
            
            GeometryReader { proxy in
                let w = proxy.size.width
                let h = proxy.size.height
                
                ZStack {
                    // 1. Top-Left: Antique Bronze
                    Circle()
                        .fill(Color(red: 155/255, green: 115/255, blue: 32/255).opacity(0.26))
                        .frame(width: w * 0.58, height: w * 0.58)
                        .position(x: animate ? w * 0.22 : w * 0.17, y: animate ? h * 0.24 : h * 0.18)
                        .blur(radius: 110)
                    
                    // 2. Top-Center: Deep Pine
                    Ellipse()
                        .fill(Color(red: 16/255, green: 52/255, blue: 30/255).opacity(0.48))
                        .frame(width: w * 0.68, height: h * 0.72)
                        .position(x: animate ? w * 0.53 : w * 0.47, y: animate ? h * 0.28 : h * 0.33)
                        .blur(radius: 120)
                    
                    // 3. Top-Right: Warm Gold Tint
                    Circle()
                        .fill(Color(red: 135/255, green: 105/255, blue: 40/255).opacity(0.18))
                        .frame(width: w * 0.52, height: w * 0.52)
                        .position(x: animate ? w * 0.83 : w * 0.77, y: animate ? h * 0.19 : h * 0.25)
                        .blur(radius: 110)
                    
                    // 4. Center-Lower: Rich Spruce
                    Ellipse()
                        .fill(Color(red: 10/255, green: 38/255, blue: 22/255).opacity(0.40))
                        .frame(width: w * 0.78, height: h * 0.62)
                        .position(x: animate ? w * 0.47 : w * 0.53, y: animate ? h * 0.68 : h * 0.62)
                        .blur(radius: 130)
                }
                .drawingGroup()
            }
            .ignoresSafeArea()
            
            // Atmospheric Vignette & Contrast Scrim
            LinearGradient(
                stops: [
                    .init(color: Color.black.opacity(0.38), location: 0.0),
                    .init(color: Color.clear, location: 0.30),
                    .init(color: Color.black.opacity(0.65), location: 0.75),
                    .init(color: Color.black.opacity(0.90), location: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        }
    }
}

extension View {
    func tvAmbientBackground() -> some View {
        self.background(TVAmbientBackground())
    }
}

// MARK: - Dynamic Greeting Helper
enum TVGreetingHelper {
    static func greeting(date: Date = Date()) -> String {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date) // 1=Sun, 6=Fri, 7=Sat
        let hour = calendar.component(.hour, from: date)
        
        // Sabbath: Friday 5:00 PM (17:00) through Saturday 5:00 PM (16:59)
        if (weekday == 6 && hour >= 17) || (weekday == 7 && hour < 17) {
            return NSLocalizedString("Home.Greeting.Sabbath", value: "Happy Sabbath!", comment: "")
        }
        
        switch hour {
        case 4..<12:
            return NSLocalizedString("Home.Greeting.Morning", value: "Good morning!", comment: "")
        case 12..<17:
            return NSLocalizedString("Home.Greeting.Afternoon", value: "Good afternoon!", comment: "")
        default:
            return NSLocalizedString("Home.Greeting.Evening", value: "Good evening!", comment: "")
        }
    }
}

// MARK: - Recents Manager
struct TVRecentItem: Codable, Identifiable, Equatable {
    var id: UUID { hymnId }
    let hymnId: UUID
    let bookKey: String
    let hymnNumber: Int
    let title: String
    let viewedAt: Date
}

@MainActor
final class TVRecentsManager: ObservableObject {
    static let shared = TVRecentsManager()
    
    @Published private(set) var recents: [TVRecentItem] = []
    
    private let userDefaultsKey = "cis.tv.recent_hymns"
    private let maxItems = 10
    
    init() {
        load()
    }
    
    func record(hymn: StoreHymn, bookKey: String) {
        var items = recents.filter { $0.hymnId != hymn.id }
        let newItem = TVRecentItem(
            hymnId: hymn.id,
            bookKey: bookKey,
            hymnNumber: hymn.number,
            title: hymn.title,
            viewedAt: Date()
        )
        items.insert(newItem, at: 0)
        recents = Array(items.prefix(maxItems))
        save()
    }
    
    private func load() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let decoded = try? JSONDecoder().decode([TVRecentItem].self, from: data) else {
            recents = []
            return
        }
        recents = Array(decoded.prefix(maxItems))
    }
    
    private func save() {
        if let data = try? JSONEncoder().encode(recents) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
}

// MARK: - Pinned Hymnals Manager
@MainActor
final class TVPinnedHymnalsManager: ObservableObject {
    static let shared = TVPinnedHymnalsManager()
    
    @Published private(set) var pinnedKeys: [String] = []
    private let userDefaultsKey = "cis.tv.pinned_hymnals"
    
    init() {
        load()
    }
    
    func isPinned(_ bookKey: String) -> Bool {
        pinnedKeys.contains(bookKey)
    }
    
    func togglePin(_ bookKey: String) {
        if let index = pinnedKeys.firstIndex(of: bookKey) {
            pinnedKeys.remove(at: index)
        } else {
            pinnedKeys.append(bookKey)
        }
        save()
    }
    
    /// Returns books with pinned hymnals floated to the front (in pin order), followed by remaining books
    func sortedBooks(_ books: [StoreBook]) -> [StoreBook] {
        let pinned = pinnedKeys.compactMap { key in books.first(where: { $0.key == key }) }
        let unpinned = books.filter { !pinnedKeys.contains($0.key) }
        return pinned + unpinned
    }
    
    /// Returns only the pinned books
    func pinnedBooks(from books: [StoreBook]) -> [StoreBook] {
        pinnedKeys.compactMap { key in books.first(where: { $0.key == key }) }
    }
    
    private func load() {
        pinnedKeys = UserDefaults.standard.stringArray(forKey: userDefaultsKey) ?? []
    }
    
    private func save() {
        UserDefaults.standard.set(pinnedKeys, forKey: userDefaultsKey)
    }
}


