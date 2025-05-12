//
//  ActionButton.swift
//  FLOV
//
//  Created by 조우현 on 5/13/25.
//

import SwiftUI

struct ActionButton: View {
    var tapAction: () -> Void
    var text: String
    var backgroundColor: Color
    
    init(text: String, color: Color = .colBlack, tapAction: @escaping () -> Void) {
        self.text = text
        self.backgroundColor = color
        self.tapAction = tapAction
    }
    
    var body: some View {
        Button {
            
        } label: {
            Text(text)
                .font(.Title.title1)
                .foregroundStyle(backgroundColor == .colBlack ? .white : .black)
                .padding()
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

#if DEBUG
#Preview {
    ActionButton(text: "로그인하기") { }
    ActionButton(text: "가입하기", color: .colLight) { }
}
#endif
