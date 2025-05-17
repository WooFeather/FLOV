//
//  ActionButton.swift
//  FLOV
//
//  Created by 조우현 on 5/13/25.
//

import SwiftUI

struct ActionButton: View {
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    var text: String
    var backgroundColor: Color = .colBlack
    var tapAction: () -> Void
    
    var body: some View {
        Button {
            tapAction()
        } label: {
            Text(text)
                .font(.Title.title1)
                .foregroundStyle(backgroundColor == .colBlack ? .white : .black)
                .padding()
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(isEnabled ? backgroundColor : .gray60)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

#if DEBUG
#Preview {
    ActionButton(text: "로그인하기") { }
    ActionButton(text: "가입하기", backgroundColor: .colLight) { }
}
#endif
