//
//  TVLyricsView.swift
//  tvOS
//

import SwiftUI

struct TVLyricsView: View {
    let hymn: StoreHymn
    let book: StoreBook?
    @EnvironmentObject private var vm: CISAppViewModel
    @EnvironmentObject private var tunePlayer: TunePlayer
    @Environment(\.dismiss) private var dismiss
    
    enum LyricsFocusArea: Hashable {
        case canvas
        case addToCollection
        case playTune
    }
    
    @FocusState private var focusedArea: LyricsFocusArea?
    @State private var isControlsHUDVisible: Bool = false
    @State private var hudDismissWorkItem: DispatchWorkItem? = nil
    
    @State private var currentVerseIndex: Int = 0
    @State private var showingAddToCollection = false
    
    private var isSDAH: Bool {
        hymn.book == "sdah"
    }
    
    private var isInAnyCollection: Bool {
        vm.allCollections.contains(where: { ($0.hymns ?? []).contains(where: { $0.id == hymn.id }) })
    }
    
    private var totalVerses: Int {
        max(1, hymn.lyrics.count)
    }
    
    private var currentLyric: StoreLyric? {
        guard !hymn.lyrics.isEmpty, currentVerseIndex < hymn.lyrics.count else { return nil }
        return hymn.lyrics[currentVerseIndex]
    }
    
    private var isChorus: Bool {
        currentLyric?.type == "refrain"
    }
    
    private var canGoBack: Bool {
        currentVerseIndex > 0
    }
    
    private var canGoForward: Bool {
        currentVerseIndex < hymn.lyrics.count - 1
    }
    
    private func goToPreviousVerse() {
        if canGoBack {
            withAnimation(.easeInOut(duration: 0.28)) {
                currentVerseIndex -= 1
            }
        }
    }
    
    private func goToNextVerse() {
        if canGoForward {
            withAnimation(.easeInOut(duration: 0.28)) {
                currentVerseIndex += 1
            }
        }
    }
    
    private func formatTime(_ time: Double) -> String {
        guard time.isFinite && !time.isNaN else { return "0:00" }
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    private func loadTune() {
        tunePlayer.load(bookKey: hymn.book, hymnNumber: hymn.number, title: hymn.title)
    }
    
    // MARK: - HUD Controls Management
    
    private func startAutoDismissTimer() {
        hudDismissWorkItem?.cancel()
        let workItem = DispatchWorkItem {
            hideControlsHUD()
        }
        hudDismissWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: workItem)
    }
    
    private func resetAutoDismissTimer() {
        if isControlsHUDVisible {
            startAutoDismissTimer()
        }
    }
    
    private func cancelAutoDismissTimer() {
        hudDismissWorkItem?.cancel()
        hudDismissWorkItem = nil
    }
    
    private func showControlsHUD() {
        cancelAutoDismissTimer()
        withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
            isControlsHUDVisible = true
        }
        focusedArea = isSDAH ? .playTune : .addToCollection
        startAutoDismissTimer()
    }
    
    private func hideControlsHUD() {
        cancelAutoDismissTimer()
        withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
            isControlsHUDVisible = false
        }
        focusedArea = .canvas
    }
    
    private func toggleControlsHUD() {
        if isControlsHUDVisible {
            hideControlsHUD()
        } else {
            showControlsHUD()
        }
    }
    
    var body: some View {
        ZStack {
            // Ambient Sacred Worship Background
            TVAmbientBackground()
            
            // Full Screen Focus Canvas (Captures remote input in Presentation Mode)
            Color.clear
                .contentShape(Rectangle())
                .focusable(!isControlsHUDVisible)
                .focused($focusedArea, equals: .canvas)
                .onTapGesture {
                    toggleControlsHUD()
                }
            
            VStack(spacing: 0) {
                // TOP BAR: Metadata on Left, On-Demand HUD on Right
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(String(format: NSLocalizedString("Lyrics.HymnNumberPrefix", comment: ""), hymn.number))
                            .font(TVStyle.uiFont(size: 16, weight: .bold))
                            .tracking(2.5)
                            .foregroundStyle(Color.white.opacity(0.85))
                        
                        Text(hymn.title)
                            .font(TVStyle.titleFont(size: 38))
                            .foregroundStyle(Color.white)
                            .lineLimit(1)
                        
                        if let bookTitle = (vm.allBooks.first(where: { $0.key == hymn.book }) ?? book)?.title {
                            Text(bookTitle)
                                .font(TVStyle.uiFont(size: 18, weight: .medium))
                                .foregroundStyle(Color.white.opacity(0.6))
                        }
                    }
                    
                    Spacer()
                    
                    // TOP RIGHT: Controls HUD (On-Demand) vs Subtle Presentation Hint
                    if isControlsHUDVisible {
                        HStack(spacing: 16) {
                            TVHUDAddToCollectionButton(
                                isInAnyCollection: isInAnyCollection,
                                isFocused: focusedArea == .addToCollection
                            ) {
                                resetAutoDismissTimer()
                                showingAddToCollection = true
                            }
                            .focused($focusedArea, equals: .addToCollection)
                            
                            if isSDAH {
                                TVHUDTuneButton(
                                    tunePlayer: tunePlayer,
                                    isFocused: focusedArea == .playTune
                                ) {
                                    resetAutoDismissTimer()
                                    if tunePlayer.isPlaying {
                                        tunePlayer.pause()
                                    } else {
                                        tunePlayer.play()
                                    }
                                }
                                .focused($focusedArea, equals: .playTune)
                            }
                        }
                        .padding(10)
                        .background(
                            Capsule()
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    Capsule().stroke(Color.white.opacity(0.18), lineWidth: 1)
                                )
                        )
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .offset(y: -16)),
                            removal: .opacity.combined(with: .offset(y: -10))
                        ))
                    } else {
                        // Subtle non-distracting presentation hint
                        Button {
                            showControlsHUD()
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "chevron.up")
                                    .font(.system(size: 12, weight: .bold))
                                Text(LocalizedStringKey("Lyrics.ControlsHint"))
                                    .font(TVStyle.uiFont(size: 13, weight: .semibold))
                            }
                            .foregroundStyle(Color.white.opacity(0.35))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(Color.white.opacity(0.06)))
                        }
                        .buttonStyle(.plain)
                        .transition(.opacity)
                    }
                }
                .padding(.horizontal, TVStyle.horizontalPadding)
                .padding(.top, 40)
                
                Spacer()
                
                // CENTER: Single Stanza Presentation View
                VStack(spacing: 24) {
                    // Stanza Identifier (e.g. 1, 2, 3 or CHORUS)
                    if isChorus {
                        Text(book?.refrainLabel?.uppercased() ?? NSLocalizedString("Common.Chorus", comment: ""))
                            .font(TVStyle.uiFont(size: 18, weight: .bold))
                            .tracking(3)
                            .foregroundStyle(Color.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(Color.white.opacity(0.18)))
                    } else if let index = currentLyric?.index {
                        Text("\(index)")
                            .font(TVStyle.uiFont(size: 26, weight: .bold))
                            .foregroundStyle(Color.white.opacity(0.85))
                    } else {
                        Text("\(currentVerseIndex + 1)")
                            .font(TVStyle.uiFont(size: 26, weight: .bold))
                            .foregroundStyle(Color.white.opacity(0.85))
                    }
                    
                    // Stanza Poetic Lines
                    if let lines = currentLyric?.lines {
                        VStack(spacing: 14) {
                            ForEach(Array(lines.enumerated()), id: \.offset) { _, line in
                                Text(line)
                                    .font(isChorus ? TVStyle.chorusFont(size: 46) : TVStyle.verseFont(size: 44))
                                    .foregroundStyle(Color.white)
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(10)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }
                .frame(maxWidth: 1400)
                .id(currentVerseIndex)
                .transition(.opacity.combined(with: .scale(scale: 0.98)))
                
                Spacer()
                
                // BOTTOM BAR: Progress Line & Non-Focusable Presentation Counter
                VStack(spacing: 16) {
                    // Thin Progress Line across screen
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.white.opacity(0.12))
                                .frame(height: 3)
                            
                            Rectangle()
                                .fill(Color.white)
                                .frame(
                                    width: max(12, geo.size.width * (CGFloat(currentVerseIndex + 1) / CGFloat(totalVerses))),
                                    height: 3
                                )
                                .animation(.easeInOut(duration: 0.25), value: currentVerseIndex)
                        }
                    }
                    .frame(height: 3)
                    
                    // Clean presentation hints (Never traps remote focus)
                    HStack {
                        HStack(spacing: 8) {
                            Image(systemName: "chevron.left")
                            Text(LocalizedStringKey("Common.Previous"))
                        }
                        .font(TVStyle.uiFont(size: 18, weight: .medium))
                        .foregroundStyle(canGoBack ? Color.white.opacity(0.55) : Color.white.opacity(0.15))
                        
                        Spacer()
                        
                        // Centered Progress Text: VERSE 1 OF 3 / CHORUS • 2 OF 4
                        Text(
                            isChorus ?
                            String(format: NSLocalizedString("Lyrics.ChorusProgress", comment: ""), currentVerseIndex + 1, totalVerses) :
                            String(format: NSLocalizedString("Lyrics.VerseProgress", comment: ""), currentVerseIndex + 1, totalVerses)
                        )
                        .font(TVStyle.uiFont(size: 16, weight: .bold))
                        .tracking(2.5)
                        .foregroundStyle(Color.white.opacity(0.55))
                        
                        Spacer()
                        
                        HStack(spacing: 8) {
                            Text(LocalizedStringKey("Common.Next"))
                            Image(systemName: "chevron.right")
                        }
                        .font(TVStyle.uiFont(size: 18, weight: .medium))
                        .foregroundStyle(canGoForward ? Color.white.opacity(0.55) : Color.white.opacity(0.15))
                    }
                }
                .padding(.horizontal, TVStyle.horizontalPadding)
                .padding(.bottom, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .onExitCommand {
            if isControlsHUDVisible {
                hideControlsHUD()
            } else if canGoBack {
                goToPreviousVerse()
            } else {
                dismiss()
            }
        }
        .onAppear {
            loadTune()
            focusedArea = .canvas
            TVRecentsManager.shared.record(hymn: hymn, bookKey: hymn.book)
        }
        .onDisappear {
            cancelAutoDismissTimer()
            if !showingAddToCollection {
                tunePlayer.stop()
            }
        }
        .onChange(of: focusedArea) { _, newFocus in
            if newFocus == .canvas && isControlsHUDVisible {
                hideControlsHUD()
            }
        }
        // Remote Direction Gestures (Zero conflicts)
        .onMoveCommand { direction in
            if !isControlsHUDVisible {
                switch direction {
                case .left:
                    goToPreviousVerse()
                case .right:
                    goToNextVerse()
                case .up:
                    showControlsHUD()
                default:
                    break
                }
            } else {
                switch direction {
                case .down:
                    hideControlsHUD()
                default:
                    resetAutoDismissTimer()
                }
            }
        }
        // Physical Play/Pause button on Siri Remote always works
        .onPlayPauseCommand {
            if isSDAH {
                if tunePlayer.isPlaying {
                    tunePlayer.pause()
                } else {
                    tunePlayer.play()
                }
            }
        }
        // Remote Select Key while on canvas summons controls
        .onKeyPress(.return) {
            if !isControlsHUDVisible {
                showControlsHUD()
                return .handled
            }
            return .ignored
        }
        .onKeyPress(.space) {
            if !isControlsHUDVisible {
                showControlsHUD()
                return .handled
            }
            return .ignored
        }
        .sheet(isPresented: $showingAddToCollection) {
            TVAddToCollectionSheet(hymn: hymn)
        }
    }
}

// MARK: - Focus-Aware HUD Subviews

private struct TVHUDAddToCollectionButton: View {
    let isInAnyCollection: Bool
    var isFocused: Bool = false
    let action: () -> Void
    @Environment(\.isFocused) private var envIsFocused
    
    private var focused: Bool {
        isFocused || envIsFocused
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: isInAnyCollection ? "bookmark.fill" : "bookmark")
                    .font(.system(size: 16, weight: .bold))
                Text(isInAnyCollection ? LocalizedStringKey("Lyrics.InCollection") : LocalizedStringKey("Lyrics.AddToCollection"))
                    .font(TVStyle.uiFont(size: 17, weight: .semibold))
            }
        }
        .buttonStyle(.borderedProminent)
        .tint(focused ? Color.white : (isInAnyCollection ? Color.white.opacity(0.35) : Color.white.opacity(0.18)))
        .foregroundStyle(focused ? Color.black : Color.white)
    }
}

private struct TVHUDTuneButton: View {
    @ObservedObject var tunePlayer: TunePlayer
    var isFocused: Bool = false
    let action: () -> Void
    @Environment(\.isFocused) private var envIsFocused
    
    private var focused: Bool {
        isFocused || envIsFocused
    }
    
    private func formatTime(_ seconds: Double) -> String {
        guard !seconds.isNaN, !seconds.isInfinite, seconds >= 0 else { return "0:00" }
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%d:%02d", mins, secs)
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: tunePlayer.isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 16, weight: .bold))
                
                Text(tunePlayer.isPlaying ? LocalizedStringKey("Tune.Pause") : LocalizedStringKey("Tune.Play"))
                    .font(TVStyle.uiFont(size: 17, weight: .semibold))
                
                if tunePlayer.hasTrack {
                    Text(formatTime(tunePlayer.currentTime) + " / " + formatTime(tunePlayer.duration))
                        .font(TVStyle.uiFont(size: 15))
                        .opacity(focused ? 0.75 : 0.85)
                }
            }
        }
        .buttonStyle(.borderedProminent)
        .tint(focused ? Color.white : (tunePlayer.isPlaying ? Color.white.opacity(0.35) : Color.white.opacity(0.18)))
        .foregroundStyle(focused ? Color.black : Color.white)
    }
}

#Preview {
    let dummyLyric1 = StoreLyric(type: "verse", index: 1, lines: [
        "Come, Thou Fount of every blessing,",
        "Tune my heart to sing Thy grace;",
        "Streams of mercy, never ceasing,",
        "Call for songs of loudest praise."
    ])
    let dummyLyric2 = StoreLyric(type: "refrain", index: nil, lines: [
        "Praise the mount! I'm fixed upon it,",
        "Mount of Thy redeeming love."
    ])
    let sampleHymn = StoreHymn(
        id: UUID(),
        title: "Come, Thou Fount of Every Blessing",
        lyrics: [dummyLyric1, dummyLyric2],
        book: "sdah",
        number: 334,
        titleEnglish: nil,
        hymnalReferences: "SDAH 334"
    )
    let sampleBook = StoreBook(key: "sdah", language: "English", title: "The Seventh-day Adventist Hymnal", isSelected: true, refrainLabel: "Chorus")
    
    return TVLyricsView(hymn: sampleHymn, book: sampleBook)
        .environmentObject(CISAppViewModel.sample)
        .environmentObject(TunePlayer())
}
