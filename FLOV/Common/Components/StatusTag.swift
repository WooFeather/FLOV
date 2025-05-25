//
//  StatusTag.swift
//  FLOV
//
//  Created by 조우현 on 5/25/25.
//

import SwiftUI

struct StatusTag: View {
    var status: ActivityStatus
    var isLongTag = false
    @State private var now = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack(spacing: 4) {
            Image(uiImage: status.icon)
                .resizable()
                .frame(width: 12, height: 12)
            
            Text(status.text)
                .font(.Caption.caption2.weight(.semibold))
                .foregroundColor(.white)
            
            if isLongTag {
                switch status {
                case .new:
                    Text("액티비티 오픈할인")
                        .font(.Caption.caption2.weight(.semibold))
                        .foregroundColor(.white)
                case .hot(let orderCount):
                    Text("총 예약 수 \(orderCount)")
                        .font(.Caption.caption2.weight(.semibold))
                        .foregroundColor(.white)
                case .deadline(let endDate):
                    Text(countdownString(until: endDate ?? Date()))
                        .font(.Caption.caption2.weight(.semibold))
                        .foregroundColor(.white)
                        .onReceive(timer) { now = $0 }
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(.gray45.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.colLight, lineWidth: 1)
        )
    }
}

extension StatusTag {
    enum ActivityStatus {
        case new
        case hot(orderCount: Int)
        case deadline(endDate: Date?)
        
        var text: String {
            switch self {
            case .new:
                return "NEW"
            case .hot:
                return "HOT"
            case .deadline:
                return "마감임박"
            }
        }
        
        var icon: UIImage {
            switch self {
            case .new:
                return .icnNew
            case .hot:
                return .icnHot
            case .deadline:
                return .icnTag
            }
        }
    }
}

private extension StatusTag {
    func countdownString(until end: Date) -> String {
        let diff = max(0, Int(end.timeIntervalSince(now)))
        let d = diff / 86400
        let h = (diff % 86400) / 3600
        let m = (diff % 3600) / 60
        let s = diff % 60
        if d > 0 {
            return "\(d)일 \(h):\(m.twoDigits):\(s.twoDigits)"
        } else
        {
            return String(format: "%02d:%02d:%02d", h, m, s)
        }
    }
}

#Preview {
    StatusTag(status: .new)
    StatusTag(status: .new, isLongTag: true)
    
    StatusTag(status: .hot(orderCount: 1000))
    StatusTag(status: .hot(orderCount: 1000), isLongTag: true)
    
    StatusTag(status: .deadline(endDate: "2025-06-07".toDate(format: "yyyy-MM-dd")), isLongTag: true)
}
