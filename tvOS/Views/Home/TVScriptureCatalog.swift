//
//  TVScriptureCatalog.swift
//  tvOS
//
//

import Foundation

struct TVScripture: Identifiable, Equatable {
    let id: String
    let text: String
    let reference: String
    let category: TVScriptureCategory
}

enum TVScriptureCategory: String, Equatable {
    case sabbath
    case praise
    case morning
    case evening
    case grace
    
    var badgeTitle: String {
        switch self {
        case .sabbath:
            return "Sabbath Praise"
        case .praise:
            return "Verse of the Day"
        case .morning:
            return "Morning Devotion"
        case .evening:
            return "Evening Praise"
        case .grace:
            return "Words of Grace"
        }
    }
}

enum TVScriptureCatalog {
    static let sabbathScriptures: [TVScripture] = [
        TVScripture(
            id: "sab_1",
            text: "It is a good thing to give thanks unto the Lord, and to sing praises unto Thy name, O Most High.",
            reference: "Psalm 92:1",
            category: .sabbath
        ),
        TVScripture(
            id: "sab_2",
            text: "Remember the Sabbath day, to keep it holy. Six days shalt thou labour, and do all thy work: But the seventh day is the Sabbath of the Lord thy God.",
            reference: "Exodus 20:8–10",
            category: .sabbath
        ),
        TVScripture(
            id: "sab_3",
            text: "If thou turn away thy foot from the sabbath, from doing thy pleasure on my holy day; and call the sabbath a delight, the holy of the Lord, honourable.",
            reference: "Isaiah 58:13",
            category: .sabbath
        ),
        TVScripture(
            id: "sab_4",
            text: "To shew forth Thy lovingkindness in the morning, and Thy faithfulness every night, upon an instrument of ten strings, and upon the psaltery.",
            reference: "Psalm 92:2–3",
            category: .sabbath
        ),
        TVScripture(
            id: "sab_5",
            text: "Hallow my sabbaths; and they shall be a sign between me and you, that ye may know that I am the Lord your God.",
            reference: "Ezekiel 20:20",
            category: .sabbath
        ),
        TVScripture(
            id: "sab_6",
            text: "For the Lord hath blessed the seventh day, and sanctified it, because that in it He had rested from all His work.",
            reference: "Genesis 2:3",
            category: .sabbath
        )
    ]
    
    static let dailyScriptures: [TVScripture] = [
        TVScripture(
            id: "prs_1",
            text: "I will sing unto the Lord as long as I live: I will sing praise to my God while I have my being.",
            reference: "Psalm 104:33",
            category: .praise
        ),
        TVScripture(
            id: "prs_2",
            text: "Praise ye the Lord: for it is good to sing praises unto our God; for it is pleasant; and praise is comely.",
            reference: "Psalm 147:1",
            category: .praise
        ),
        TVScripture(
            id: "prs_3",
            text: "O come, let us sing unto the Lord: let us make a joyful noise to the rock of our salvation.",
            reference: "Psalm 95:1",
            category: .praise
        ),
        TVScripture(
            id: "prs_4",
            text: "Make a joyful noise unto the Lord, all ye lands. Serve the Lord with gladness: come before His presence with singing.",
            reference: "Psalm 100:1–2",
            category: .praise
        ),
        TVScripture(
            id: "prs_5",
            text: "O sing unto the Lord a new song: sing unto the Lord, all the earth. Sing unto the Lord, bless His name; shew forth His salvation from day to day.",
            reference: "Psalm 96:1–2",
            category: .praise
        ),
        TVScripture(
            id: "prs_6",
            text: "Let the word of Christ dwell in you richly in all wisdom; teaching and admonishing one another in psalms and hymns and spiritual songs, singing with grace in your hearts to the Lord.",
            reference: "Colossians 3:16",
            category: .praise
        ),
        TVScripture(
            id: "prs_7",
            text: "Speaking to yourselves in psalms and hymns and spiritual songs, singing and making melody in your heart to the Lord.",
            reference: "Ephesians 5:19",
            category: .praise
        ),
        TVScripture(
            id: "prs_8",
            text: "It is of the Lord’s mercies that we are not consumed, because His compassions fail not. They are new every morning: great is Thy faithfulness.",
            reference: "Lamentations 3:22–23",
            category: .morning
        ),
        TVScripture(
            id: "prs_9",
            text: "My voice shalt Thou hear in the morning, O Lord; in the morning will I direct my prayer unto Thee, and will look up.",
            reference: "Psalm 5:3",
            category: .morning
        ),
        TVScripture(
            id: "prs_10",
            text: "But I will sing of Thy power; yea, I will sing aloud of Thy mercy in the morning: for Thou hast been my defence and refuge in the day of my trouble.",
            reference: "Psalm 59:16",
            category: .morning
        ),
        TVScripture(
            id: "prs_11",
            text: "Sing praises to God, sing praises: sing praises unto our King, sing praises. For God is the King of all the earth: sing ye praises with understanding.",
            reference: "Psalm 47:6–7",
            category: .praise
        ),
        TVScripture(
            id: "prs_12",
            text: "Because Thy lovingkindness is better than life, my lips shall praise Thee. Thus will I bless Thee while I live: I will lift up my hands in Thy name.",
            reference: "Psalm 63:3–4",
            category: .praise
        ),
        TVScripture(
            id: "prs_13",
            text: "Rejoice in the Lord alway: and again I say, Rejoice. Let your moderation be known unto all men. The Lord is at hand.",
            reference: "Philippians 4:4–5",
            category: .grace
        ),
        TVScripture(
            id: "prs_14",
            text: "The Lord thy God in the midst of thee is mighty; He will save, He will rejoice over thee with joy; He will rest in His love, He will joy over thee with singing.",
            reference: "Zephaniah 3:17",
            category: .grace
        ),
        TVScripture(
            id: "prs_15",
            text: "My lips shall greatly rejoice when I sing unto Thee; and my soul, which Thou hast redeemed.",
            reference: "Psalm 71:23",
            category: .praise
        ),
        TVScripture(
            id: "prs_16",
            text: "I will sing of the mercies of the Lord for ever: with my mouth will I make known Thy faithfulness to all generations.",
            reference: "Psalm 89:1",
            category: .praise
        ),
        TVScripture(
            id: "prs_17",
            text: "Rejoice in the Lord, O ye righteous: for praise is comely for the upright. Praise the Lord with harp: sing unto Him with the psaltery and an instrument of ten strings.",
            reference: "Psalm 33:1–2",
            category: .praise
        ),
        TVScripture(
            id: "prs_18",
            text: "This is the day which the Lord hath made; we will rejoice and be glad in it.",
            reference: "Psalm 118:24",
            category: .praise
        ),
        TVScripture(
            id: "prs_19",
            text: "Let every thing that hath breath praise the Lord. Praise ye the Lord.",
            reference: "Psalm 150:6",
            category: .praise
        ),
        TVScripture(
            id: "prs_20",
            text: "Great and marvellous are Thy works, Lord God Almighty; just and true are Thy ways, Thou King of saints.",
            reference: "Revelation 15:3",
            category: .praise
        ),
        TVScripture(
            id: "prs_21",
            text: "Cause me to hear Thy lovingkindness in the morning; for in Thee do I trust: cause me to know the way wherein I should walk.",
            reference: "Psalm 143:8",
            category: .morning
        ),
        TVScripture(
            id: "prs_22",
            text: "O satisfy us early with Thy mercy; that we may rejoice and be glad all our days.",
            reference: "Psalm 90:14",
            category: .morning
        ),
        TVScripture(
            id: "prs_23",
            text: "The Lord is my strength and my shield; my heart trusted in Him, and I am helped: therefore my heart greatly rejoiceth; and with my song will I praise Him.",
            reference: "Psalm 28:7",
            category: .praise
        ),
        TVScripture(
            id: "prs_24",
            text: "Now the God of hope fill you with all joy and peace in believing, that ye may abound in hope, through the power of the Holy Ghost.",
            reference: "Romans 15:13",
            category: .grace
        ),
        TVScripture(
            id: "prs_25",
            text: "But they that wait upon the Lord shall renew their strength; they shall mount up with wings as eagles; they shall run, and not be weary; and they shall walk, and not faint.",
            reference: "Isaiah 40:31",
            category: .grace
        ),
        TVScripture(
            id: "eve_1",
            text: "The Lord will command His lovingkindness in the daytime, and in the night His song shall be with me, and my prayer unto the God of my life.",
            reference: "Psalm 42:8",
            category: .evening
        ),
        TVScripture(
            id: "eve_2",
            text: "I will both lay me down in peace, and sleep: for Thou, Lord, only makest me dwell in safety.",
            reference: "Psalm 4:8",
            category: .evening
        ),
        TVScripture(
            id: "eve_3",
            text: "Behold, bless ye the Lord, all ye servants of the Lord, which by night stand in the house of the Lord. Lift up your hands in the sanctuary, and bless the Lord.",
            reference: "Psalm 134:1–2",
            category: .evening
        )
    ]
    
    /// Returns whether the provided date falls within Sabbath hours (Friday 5:00 PM to Saturday 5:00 PM)
    static func isSabbathHours(date: Date = Date(), calendar: Calendar = .current) -> Bool {
        let weekday = calendar.component(.weekday, from: date) // 1=Sun, 6=Fri, 7=Sat
        let hour = calendar.component(.hour, from: date)
        return (weekday == 6 && hour >= 17) || (weekday == 7 && hour < 17)
    }
    
    /// Returns the scripture for today, rotating daily and aware of the time of day (morning vs. afternoon vs. evening)
    static func todayScripture(date: Date = Date(), calendar: Calendar = .current) -> TVScripture {
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
        let hour = calendar.component(.hour, from: date)
        let isMorning = (hour >= 4 && hour < 12)
        let isEvening = (hour >= 17 || hour < 4)
        
        if isSabbathHours(date: date, calendar: calendar) {
            let index = dayOfYear % sabbathScriptures.count
            return sabbathScriptures[index]
        } else {
            // Filter out time-inappropriate verses:
            // - Exclude morning-specific verses when it is not morning
            // - Exclude evening-specific verses when it is not evening
            let eligible = dailyScriptures.filter { item in
                if item.category == .morning && !isMorning {
                    return false
                }
                if item.category == .evening && !isEvening {
                    return false
                }
                return true
            }
            
            let list = eligible.isEmpty ? dailyScriptures : eligible
            let index = dayOfYear % list.count
            return list[index]
        }
    }
}
