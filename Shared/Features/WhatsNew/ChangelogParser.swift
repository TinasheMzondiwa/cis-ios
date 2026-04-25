import Foundation

struct ChangelogParser {
    static func parse(for version: String, from markdown: String) -> [WhatsNewItem] {
        var items: [WhatsNewItem] = []
        
        // Find the section for the specific version
        let versionHeader = "# \(version)"
        guard let versionRange = markdown.range(of: versionHeader) else {
            return []
        }
        
        let startIdx = versionRange.upperBound
        
        // Find the next version header to know where to stop
        var endIdx = markdown.endIndex
        if let nextVersionRange = markdown.range(of: "\n# ", range: startIdx..<markdown.endIndex) {
            endIdx = nextVersionRange.lowerBound
        }
        
        let versionContent = String(markdown[startIdx..<endIdx])
        
        // Parse items
        // Look for ### SF:{icon} {title}
        // followed by description text until the next ###
        
        let itemComponents = versionContent.components(separatedBy: "### ").filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        
        for component in itemComponents {
            var lines = component.components(separatedBy: .newlines).filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
            guard !lines.isEmpty else { continue }
            
            let headerLine = lines.removeFirst()
            var iconName = "star.fill" // default
            var title = headerLine
            
            if headerLine.hasPrefix("SF:") {
                let parts = headerLine.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)
                if parts.count == 2 {
                    iconName = String(parts[0].dropFirst(3)) // remove "SF:"
                    title = String(parts[1])
                } else if parts.count == 1 {
                    iconName = String(parts[0].dropFirst(3))
                    title = ""
                }
            }
            
            let description = lines.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
            
            items.append(WhatsNewItem(title: title, description: description, iconName: iconName))
        }
        
        return items
    }
    
    static func getWhatsNewItems(for version: String) -> [WhatsNewItem] {
        guard let url = Bundle.main.url(forResource: "changelog", withExtension: "md"),
              let content = try? String(contentsOf: url) else {
            return []
        }
        return parse(for: version, from: content)
    }
}
