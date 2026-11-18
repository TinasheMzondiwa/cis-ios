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
    
    private var collections: [StoreCollection] {
        vm.allCollections
    }
    
    private func isHymn(in collection: StoreCollection) -> Bool {
        collection.hymns?.contains(where: { $0.id == hymn.id }) ?? false
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text(LocalizedStringKey("Lyrics.SelectCollections"))
                        .font(TVStyle.titleFont(size: 38))
                        .foregroundStyle(Color.white)
                    
                    Text("\(String(format: NSLocalizedString("Lyrics.HymnNumberPrefix", comment: ""), hymn.number)) • \(hymn.title)")
                        .font(TVStyle.uiFont(size: 20, weight: .semibold))
                        .foregroundStyle(TVStyle.accentGold)
                    
                    Text(LocalizedStringKey("Lyrics.SelectCollectionsDesc"))
                        .font(TVStyle.uiFont(size: 18))
                        .foregroundStyle(Color.white.opacity(0.65))
                }
                .padding(.top, 24)
                
                // Add New Collection Action
                Button {
                    showingCreateDialog = true
                } label: {
                    Label(LocalizedStringKey("Collections.Create"), systemImage: "plus.circle.fill")
                        .font(TVStyle.uiFont(size: 20, weight: .bold))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                }
                .buttonStyle(.borderedProminent)
                .tint(TVStyle.accentGold)
                .foregroundStyle(Color.black)
                
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
                    ScrollView {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 20),
                                GridItem(.flexible(), spacing: 20)
                            ],
                            spacing: 20
                        ) {
                            ForEach(collections) { col in
                                let included = isHymn(in: col)
                                Button {
                                    vm.toggle(hymn: hymn, collection: col)
                                } label: {
                                    HStack(spacing: 16) {
                                        Image(systemName: included ? "checkmark.circle.fill" : "circle")
                                            .font(.system(size: 28, weight: .bold))
                                            .foregroundStyle(included ? TVStyle.accentGold : Color.white.opacity(0.4))
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(col.title)
                                                .font(TVStyle.uiFont(size: 22, weight: .bold))
                                                .foregroundStyle(Color.white)
                                                .lineLimit(1)
                                            
                                            Text(String(format: NSLocalizedString("Collections.HymnsCount", comment: ""), col.hymns?.count ?? 0))
                                                .font(TVStyle.uiFont(size: 16))
                                                .foregroundStyle(Color.white.opacity(0.6))
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding(20)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(
                                        RoundedRectangle(cornerRadius: TVStyle.cardCornerRadius)
                                            .fill(included ? TVStyle.accentGold.opacity(0.12) : TVStyle.cardBackground)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: TVStyle.cardCornerRadius)
                                            .stroke(included ? TVStyle.accentGold.opacity(0.6) : TVStyle.cardBorder, lineWidth: 1)
                                    )
                                }
                                .buttonStyle(.card)
                            }
                        }
                        .padding(.horizontal, 60)
                        .padding(.top, 16)
                        .padding(.bottom, 40)
                    }
                }
                
                // Done Button
                Button {
                    dismiss()
                } label: {
                    Text(LocalizedStringKey("Common.Done"))
                        .font(TVStyle.uiFont(size: 20, weight: .semibold))
                        .padding(.horizontal, 36)
                        .padding(.vertical, 10)
                }
                .buttonStyle(.bordered)
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
