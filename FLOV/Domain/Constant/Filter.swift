//
//  Country.swift
//  FLOV
//
//  Created by 조우현 on 5/25/25.
//

import SwiftUI

enum Country: CaseIterable {
    case korea
    case japan
    case philippines
    case thailand
    case taiwan
    case argentina
    case australia
    
    var flag: UIImage {
        switch self {
        case .korea:
            return .flagKorea
        case .japan:
            return .flagJapan
        case .philippines:
            return .flagPhilippines
        case .thailand:
            return .flagThailand
        case .taiwan:
            return .flagTaiwan
        case .argentina:
            return .flagArgentina
        case .australia:
            return .flagAustralia
        }
    }
    
    var title: String {
        switch self {
        case .korea:
            return "대한민국"
        case .japan:
            return "일본"
        case .philippines:
            return "필리핀"
        case .thailand:
            return "태국"
        case .taiwan:
            return "대만"
        case .argentina:
            return "아르헨티나"
        case .australia:
            return "호주"
        }
    }
}

enum ActivityType: CaseIterable {
    case sightseeing
    case tour
    case package
    case exciting
    case experience
    case random
    
    var title: String {
        switch self {
        case .sightseeing:
            return "관광"
        case .tour:
            return "투어"
        case .package:
            return "패키지"
        case .exciting:
            return "익사이팅"
        case .experience:
            return "체험"
        case .random:
            return "랜덤"
        }
    }
    
    var query: String {
        switch self {
        case .sightseeing, .tour, .package, .exciting, .experience:
            return title
        case .random:
            return ["관광", "투어", "패키지", "익사이팅", "체험"].randomElement()!
        }
    }
}
