//
//  ChatRoomView.swift
//  FLOV
//
//  Created by 조우현 on 6/3/25.
//

import SwiftUI

struct ChatRoomView: View {
    @EnvironmentObject var pathModel: PathModel
    @StateObject var viewModel: ChatRoomViewModel
    
    var body: some View {
        Text(viewModel.opponentId)
    }
}
