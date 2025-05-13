//
//  UnderlineTextButton.swift
//  FLOV
//
//  Created by 조우현 on 5/13/25.
//

import SwiftUI

struct UnderlineTextButton: View {
    var buttonTitle: String
    var tapAction: () -> Void
    
    init(_ buttonTitle: String, tapAction: @escaping () -> Void) {
        self.buttonTitle = buttonTitle
        self.tapAction = tapAction
    }
    
    var body: some View {
        Button {
            tapAction()
        } label: {
            Text(buttonTitle)
                .font(.Body.body3.bold())
                .foregroundStyle(.colDeep)
                .overlay(
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(.colDeep), alignment: .bottom)
        }
    }
}

#if DEBUG
#Preview {
    UnderlineTextButton("이메일 중복확인") { }
}
#endif
