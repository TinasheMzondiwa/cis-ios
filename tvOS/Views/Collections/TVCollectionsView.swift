//
//  TVCollectionsView.swift
//  tvOS
//

import SwiftUI

struct TVCollectionsView: View {
    @EnvironmentObject private var vm: CISAppViewModel
    var onNavigateToBrowse: (() -> Void)? = nil
    
    @State private var selectedCollectionId: UUID?
    @State private var activeLyricsHymn: StoreHymn?
    @State private var activeLyricsBook: StoreBook?
    
    @State private var showingCreateDialog = false
    @State private var showingDeleteDialog = false
    @State private var newCollectionTitle = ""
    @State private var newCollectionAbout = ""
    
    private var collections: [StoreCollection] {
        vm.allCollections
    }
    
    private var activeCollection: StoreCollection? {
        if let id = selectedCollectionId {
            return collections.first(where: { $0.id == id })
        }
        return collections.first
    }
    
    var body: some View {
        Group {
            if collections.isEmpty {
                // Global Empty State when no collections have been created
                VStack(spacing: 24) {
                    Image(systemName: "music.note.list")
                        .font(.system(size: 80))
                        .foregroundStyle(TVStyle.accentGold.opacity(0.6))
                    
                    Text(LocalizedStringKey("Collections.Empty.Title"))
                        .font(TVStyle.titleFont(size: 38))
                        .foregroundStyle(Color.white)
                    
                    Text(LocalizedStringKey("Collections.Empty.Subtitle"))
                        .font(TVStyle.uiFont(size: 20))
                        .foregroundStyle(Color.white.opacity(0.65))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 680)
                    
                    Button {
                        showingCreateDialog = true
                    } label: {
                        Label(LocalizedStringKey("Collections.CreateFirst"), systemImage: "plus.circle.fill")
                            .font(TVStyle.uiFont(size: 20, weight: .bold))
                            .padding(.horizontal, 28)
                            .padding(.vertical, 14)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(TVStyle.accentGold)
                    .foregroundStyle(Color.black)
                    .padding(.top, 12)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                // Master-Detail Layout: Left Sidebar + Right Collection Detail
                HStack(alignment: .top, spacing: 48) {
                    // LEFT SIDEBAR: Collections List
                    VStack(alignment: .leading, spacing: 18) {
                        // Sidebar Header: Title + Create Button
                        HStack(alignment: .center) {
                            Text(LocalizedStringKey("Collections.Worship"))
                                .font(TVStyle.titleFont(size: 30))
                                .foregroundStyle(Color.white)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            Button {
                                showingCreateDialog = true
                            } label: {
                                Image(systemName: "plus")
                                    .font(.system(size: 18, weight: .bold))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                            }
                            .buttonStyle(.bordered)
                            .tint(TVStyle.accentGold)
                        }
                        .padding(.horizontal, 16)
                        
                        // Collections List ScrollView with focus clearance
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 16) {
                                ForEach(collections) { col in
                                    let isSelected = (col.id == activeCollection?.id)
                                    Button {
                                        selectedCollectionId = col.id
                                    } label: {
                                        HStack(spacing: 16) {
                                            // Golden/Translucent Playlist Emblem
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(isSelected ? TVStyle.accentGold : Color.white.opacity(0.12))
                                                    .frame(width: 48, height: 48)
                                                
                                                Image(systemName: "music.note.list")
                                                    .font(.system(size: 20, weight: .bold))
                                                    .foregroundStyle(isSelected ? Color.black : TVStyle.accentGold)
                                            }
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(col.title)
                                                    .font(TVStyle.uiFont(size: 20, weight: .bold))
                                                    .foregroundStyle(Color.white)
                                                    .lineLimit(1)
                                                
                                                Text(String(format: NSLocalizedString("Collections.HymnsCount", comment: ""), col.hymns?.count ?? 0))
                                                    .font(TVStyle.uiFont(size: 15))
                                                    .foregroundStyle(Color.white.opacity(0.6))
                                            }
                                            
                                            Spacer()
                                            
                                            if isSelected {
                                                Image(systemName: "chevron.right")
                                                    .font(.system(size: 14, weight: .bold))
                                                    .foregroundStyle(TVStyle.accentGold)
                                            }
                                        }
                                        .padding(.horizontal, 18)
                                        .padding(.vertical, 14)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(isSelected ? Color.white.opacity(0.14) : TVStyle.cardBackground)
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(isSelected ? TVStyle.accentGold.opacity(0.8) : TVStyle.cardBorder, lineWidth: isSelected ? 2 : 1)
                                        )
                                    }
                                    .buttonStyle(.card)
                                }
                            }
                            .padding(.horizontal, 18)
                            .padding(.top, 28)
                            .padding(.bottom, 60)
                        }
                    }
                    .frame(width: 460)
                    
                    // RIGHT DETAIL PANE: Active Collection Details & Hymns
                    VStack(alignment: .leading, spacing: 22) {
                        if let active = activeCollection {
                            // Detail Header: Title, Description, and Cohesive Actions
                            VStack(alignment: .leading, spacing: 14) {
                                Text(active.title)
                                    .font(TVStyle.titleFont(size: 40))
                                    .foregroundStyle(Color.white)
                                
                                if let about = active.about, !about.isEmpty {
                                    Text(about)
                                        .font(TVStyle.uiFont(size: 20))
                                        .foregroundStyle(Color.white.opacity(0.68))
                                }
                                
                                // Action Buttons Row directly beneath collection details
                                HStack(spacing: 18) {
                                    let hymns = active.hymns ?? []
                                    if !hymns.isEmpty, let first = hymns.first {
                                        Button {
                                            let book = vm.allBooks.first(where: { $0.key == first.book }) ?? vm.selectedBook
                                            activeLyricsBook = book
                                            activeLyricsHymn = first
                                        } label: {
                                            Label(LocalizedStringKey("Collections.SingCollection"), systemImage: "play.fill")
                                                .font(TVStyle.uiFont(size: 18, weight: .bold))
                                                .padding(.horizontal, 22)
                                                .padding(.vertical, 12)
                                        }
                                        .buttonStyle(.borderedProminent)
                                        .tint(TVStyle.accentGold)
                                        .foregroundStyle(Color.black)
                                    }
                                    
                                    Button(role: .destructive) {
                                        showingDeleteDialog = true
                                    } label: {
                                        Label(LocalizedStringKey("Collections.Delete"), systemImage: "trash")
                                            .font(TVStyle.uiFont(size: 16, weight: .semibold))
                                            .padding(.horizontal, 18)
                                            .padding(.vertical, 12)
                                    }
                                    .buttonStyle(.bordered)
                                    .tint(Color.red.opacity(0.85))
                                }
                                .padding(.top, 4)
                            }
                            .padding(.top, 6)
                            
                            // Hymns Content: Empty prompt or 2-column grid
                            let hymns = active.hymns ?? []
                            if hymns.isEmpty {
                                VStack(spacing: 20) {
                                    Spacer()
                                    Image(systemName: "music.note.list")
                                        .font(.system(size: 64))
                                        .foregroundStyle(TVStyle.accentGold.opacity(0.4))
                                    
                                    Text(LocalizedStringKey("Collections.NoHymns"))
                                        .font(TVStyle.uiFont(size: 26, weight: .semibold))
                                        .foregroundStyle(Color.white)
                                    
                                    Text(LocalizedStringKey("Collections.EmptyCollection.Desc"))
                                        .font(TVStyle.uiFont(size: 18))
                                        .foregroundStyle(Color.white.opacity(0.6))
                                        .multilineTextAlignment(.center)
                                        .frame(maxWidth: 520)
                                    
                                    Button {
                                        onNavigateToBrowse?()
                                    } label: {
                                        Label(LocalizedStringKey("Collections.BrowseHymnals"), systemImage: "books.vertical.fill")
                                            .font(TVStyle.uiFont(size: 18, weight: .semibold))
                                            .padding(.horizontal, 24)
                                            .padding(.vertical, 12)
                                    }
                                    .buttonStyle(.bordered)
                                    .tint(TVStyle.accentGold)
                                    .padding(.top, 8)
                                    
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            } else {
                                ScrollView(.vertical, showsIndicators: false) {
                                    LazyVGrid(
                                        columns: [
                                            GridItem(.flexible(), spacing: 24),
                                            GridItem(.flexible(), spacing: 24)
                                        ],
                                        spacing: 24
                                    ) {
                                        ForEach(hymns, id: \.id) { hymn in
                                            let book = vm.allBooks.first(where: { $0.key == hymn.book })
                                            TVHymnGridCard(hymn: hymn, bookTitle: book?.title) {
                                                activeLyricsBook = book
                                                activeLyricsHymn = hymn
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.top, 32)
                                    .padding(.bottom, 60)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, TVStyle.horizontalPadding)
                .padding(.top, 32)
            }
        }
        .tvAmbientBackground()
        .navigationDestination(item: $activeLyricsHymn) { hymn in
            let book = activeLyricsBook ?? vm.allBooks.first(where: { $0.key == hymn.book }) ?? vm.selectedBook
            TVLyricsView(hymn: hymn, book: book)
        }
        // Create Collection Dialog
        .alert(LocalizedStringKey("Collections.Create"), isPresented: $showingCreateDialog) {
            TextField(LocalizedStringKey("Collections.TitlePrompt"), text: $newCollectionTitle)
            TextField(LocalizedStringKey("Collections.AboutPrompt"), text: $newCollectionAbout)
            Button(LocalizedStringKey("Common.Save")) {
                let trimmed = newCollectionTitle.trimmingCharacters(in: .whitespaces)
                guard !trimmed.isEmpty else { return }
                let about = newCollectionAbout.trimmingCharacters(in: .whitespaces)
                vm.addCollection(with: trimmed, and: about.isEmpty ? nil : about)
                newCollectionTitle = ""
                newCollectionAbout = ""
                if let created = vm.allCollections.first(where: { $0.title == trimmed }) {
                    selectedCollectionId = created.id
                }
            }
            Button(LocalizedStringKey("Common.Cancel"), role: .cancel) {
                newCollectionTitle = ""
                newCollectionAbout = ""
            }
        }
        // Delete Confirmation Dialog
        .alert(LocalizedStringKey("Collections.Delete"), isPresented: $showingDeleteDialog) {
            Button(LocalizedStringKey("Collections.Delete"), role: .destructive) {
                if let active = activeCollection {
                    vm.removeCollection(with: active.id)
                    selectedCollectionId = nil
                }
            }
            Button(LocalizedStringKey("Common.Cancel"), role: .cancel) {}
        } message: {
            Text(LocalizedStringKey("Collections.DeleteConfirm"))
        }
        .onAppear {
            if vm.allCollections.isEmpty {
                vm.addCollection(with: "Sabbath Songs", and: "We love these during rest")
            }
        }
    }
}
