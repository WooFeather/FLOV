//
//  RoundedTextField.swift
//  FLOV
//
//  Created by 조우현 on 5/13/25.
//

import SwiftUI

struct RoundedTextField: View {
    var fieldTitle: String
    var text: Binding<String>
    var placeholder = ""
    var isSecureField = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(fieldTitle)
                .font(.Body.body2)
                .foregroundStyle(.gray90)
            
            if isSecureField {
                SecureField(placeholder, text: text)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.colBlack, lineWidth: 1)
                    )
            } else {
                TextField(placeholder, text: text)
                    .autocapitalization(.none)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.colBlack, lineWidth: 1)
                    )
            }
        }
    }
}
