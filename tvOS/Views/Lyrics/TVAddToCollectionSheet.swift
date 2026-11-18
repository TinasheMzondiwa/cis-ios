//
//  TVAddToCollectionSheet.swift
//  tvOS
//

import SwiftUI

struct TVAddToCollectionSheet: View {
    let hymn: StoreHymn
    @EnvironmentObject private var vm: CISAppViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingCreateDialog = false
    @State private var newCollectionTitle = ""
    @State private var newCollectionAbout = ""
    @FocusState private var focusedCollectionId: UUID?
    @FocusState private var isNewColFocused: Bool
    @FocusState private var isDoneFocused: Bool
    
    private var collections: [StoreCollection] {
        vm.allCollections
    }
    
    private func isHymn(in collection: StoreCollection) -> Bool {
        collection.hymns?.contains(where: { $0.id == hymn.id }) ?? false
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 6) {
                    Text(LocalizedStringKey("Lyrics.SelectCollections"))
                        .font(TVStyle.titleFont(size: 36))
                        .foregroundStyle(Color.white)
                    
                    Text("\(String(format: NSLocalizedString("Lyrics.HymnNumberPrefix", comment: ""), hymn.number)) • \(hymn.title)")
                        .font(TVStyle.uiFont(size: 19, weight: .semibold))
                        .foregroundStyle(Color.white.opacity(0.85))
                        .lineLimit(1)
                    
                    Text(LocalizedStringKey("Lyrics.SelectCollectionsDesc"))
                        .font(TVStyle.uiFont(size: 16))
                        .foregroundStyle(Color.white.opacity(0.65))
                }
                .padding(.top, 24)
                
                // Add New Collection Action
                Button {
                    showingCreateDialog = true
                } label: {
                    Label(LocalizedStringKey("Collections.Create"), systemImage: "plus.circle.fill")
                        .font(TVStyle.uiFont(size: 18, weight: .bold))
                        .padding(.horizontal, 22)
                        .padding(.vertical, 10)
                }
                .buttonStyle(.borderedProminent)
                .tint(isNewColFocused ? Color.white : Color.white.opacity(0.18))
                .foregroundStyle(isNewColFocused ? Color.black : Color.white)
                .focused($isNewColFocused)
                
                if collections.isEmpty {
                    VStack(spacing: 14) {
                        Image(systemName: "music.note.list")
                            .font(.system(size: 56))
                            .foregroundStyle(Color.white.opacity(0.3))
                        Text(LocalizedStringKey("Collections.Empty.Title"))
                            .font(TVStyle.uiFont(size: 24, weight: .semibold))
                            .foregroundStyle(Color.white)
                        Text(LocalizedStringKey("Collections.Empty.Subtitle"))
                            .font(TVStyle.uiFont(size: 18))
                            .foregroundStyle(Color.white.opacity(0.6))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: 600)
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    List {
                        Section {
                            ForEach(collections) { col in
                                let included = isHymn(in: col)
                                Button {
                                    vm.toggle(hymn: hymn, collection: col)
                                } label: {
                                    TVCollectionSheetListRow(
                                        collection: col,
                                        isIncluded: included,
                                        isRowFocused: focusedCollectionId == col.id
                                    )
                                }
                                .focused($focusedCollectionId, equals: col.id)
                            }
                        }
                    }
                    .frame(maxWidth: 820)
                }
                
                // Done Button
                Button {
                    dismiss()
                } label: {
                    Text(LocalizedStringKey("Common.Done"))
                        .font(TVStyle.uiFont(size: 18, weight: .semibold))
                        .padding(.horizontal, 36)
                        .padding(.vertical, 10)
                }
                .buttonStyle(.borderedProminent)
                .tint(isDoneFocused ? Color.white : Color.white.opacity(0.18))
                .foregroundStyle(isDoneFocused ? Color.black : Color.white)
                .focused($isDoneFocused)
                .padding(.bottom, 24)
            }
            .tvAmbientBackground()
            .alert(LocalizedStringKey("Collections.Create"), isPresented: $showingCreateDialog) {
                TextField(LocalizedStringKey("Collections.TitlePrompt"), text: $newCollectionTitle)
                TextField(LocalizedStringKey("Collections.AboutPrompt"), text: $newCollectionAbout)
                Button(LocalizedStringKey("Common.Save")) {
                    let trimmedTitle = newCollectionTitle.trimmingCharacters(in: .whitespaces)
                    guard !trimmedTitle.isEmpty else { return }
                    let trimmedAbout = newCollectionAbout.trimmingCharacters(in: .whitespaces)
                    vm.addCollection(with: trimmedTitle, and: trimmedAbout.isEmpty ? nil : trimmedAbout)
                    newCollectionTitle = ""
                    newCollectionAbout = ""
                    // Automatically add the current hymn to the newly created collection
                    if let newlyCreated = vm.allCollections.first(where: { $0.title == trimmedTitle }) {
                        vm.toggle(hymn: hymn, collection: newlyCreated)
                    }
                }
                Button(LocalizedStringKey("Common.Cancel"), role: .cancel) {
                    newCollectionTitle = ""
                    newCollectionAbout = ""
                }
            }
        }
    }
}

// MARK: - Focus-Aware Sheet List Row
private struct TVCollectionSheetListRow: View {
    let collection: StoreCollection
    let isIncluded: Bool
    var isRowFocused: Bool = false
    @Environment(\.isFocused) private var envIsFocused
    
    private var isFocused: Bool {
        isRowFocused || envIsFocused
    }
    
    var body: some View {
        HStack(spacing: 20) {
            // Checkmark Indicator
            Image(systemName: isIncluded ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(isFocused ? (isIncluded ? Color.black : Color.black.opacity(0.45)) : (isIncluded ? Color.white : Color.white.opacity(0.4)))
            
            // Collection Details
            VStack(alignment: .leading, spacing: 4) {
                Text(collection.title)
                    .font(TVStyle.uiFont(size: 22, weight: .bold))
                    .foregroundStyle(isFocused ? Color.black : Color.white)
                    .lineLimit(1)
                
                Text(String(format: NSLocalizedString("Collections.HymnsCount", comment: ""), collection.hymns?.count ?? 0))
                    .font(TVStyle.uiFont(size: 16))
                    .foregroundStyle(isFocused ? Color.black.opacity(0.70) : Color.white.opacity(0.6))
            }
            
            Spacer()
            
            // "In Collection" pill indicator
            if isIncluded {
                Text(LocalizedStringKey("Lyrics.InCollection"))
                    .font(TVStyle.uiFont(size: 14, weight: .bold))
                    .foregroundStyle(isFocused ? Color.black.opacity(0.85) : Color.white.opacity(0.9))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        Capsule().fill(isFocused ? Color.black.opacity(0.10) : Color.white.opacity(0.14))
                    )
            }
        }
        .padding(.vertical, 10)
    }
}
