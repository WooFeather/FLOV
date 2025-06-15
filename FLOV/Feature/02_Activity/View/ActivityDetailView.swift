//
//  ActivityDetailView.swift
//  FLOV
//
//  Created by 조우현 on 5/16/25.
//

import SwiftUI
import WebKit
import iamport_ios

struct ActivityDetailView: View {
    @EnvironmentObject var pathModel: PathModel
    @StateObject var viewModel: ActivityDetailViewModel
    @State private var currentIndex = 0
    @State private var webView: WKWebView?
    
    var body: some View {
        VStack {
            if viewModel.output.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                detailInfoView()
                paymentView()
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .asNavigationToolbar()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                keepButton()
            }
        }
        .onAppear {
            viewModel.action(.fetchActivityDetail)
        }
        .ignoresSafeArea()
    }
}

// MARK: - DetailInfo
private extension ActivityDetailView {
    func detailInfoView() -> some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                VStack(spacing: -150) {
                    thumbnailView()
                    headerView()
                }
                curriculumView()
                reservationView()
                creatorView()
            }
        }
    }
}

// MARK: - Thumbnail
private extension ActivityDetailView {
    func thumbnailView() -> some View {
        let urls = viewModel.output.activityDetails.summary.thumbnailURLs
        
        return ZStack {
            TabView(selection: $currentIndex) {
                ForEach(urls.indices, id: \.self) { idx in
                    let path = urls[idx]
                    KFRemoteImageView(
                        path: path,
                        aspectRatio: 3/4,
                        cachePolicy: .memoryOnly,
                        height: 590
                    )
                    .tag(idx)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(maxWidth: .infinity)
            .frame(height: 590)
            
            VStack {
                Spacer()
                CustomIndicator(count: urls.count, currentIndex: currentIndex)
                
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.clear,
                        Color.white.opacity(0.3),
                        Color.white.opacity(0.5),
                        Color.white.opacity(0.8),
                        Color.white
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 120)
            }
        }
        .offset(y: -30)
    }
}

// MARK: - Header
private extension ActivityDetailView {
    func headerView() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(viewModel.output.activityDetails.summary.title)
                .font(.Body.body0)
                .foregroundStyle(.gray90)
                .lineLimit(1)
            
            HStack(spacing: 12) {
                Text(viewModel.output.activityDetails.summary.country)
                    .font(.Body.body1.bold())
                    .foregroundStyle(.gray75)
                
                PointView(point: viewModel.output.activityDetails.summary.pointReward ?? 0)
                
                // TODO: Review정보
            }
            
            Text(viewModel.output.activityDetails.description ?? "설명이 없습니다.")
                .font(.Caption.caption1)
                .foregroundStyle(.gray60)
                .multilineTextAlignment(.leading)
            
            countView()
            restrictionView()
            priceView()
        }
        .padding()
    }
    
    func countView() -> some View {
        HStack(spacing: 12) {
            HStack(spacing: 2) {
                Image(.icnBuyCount)
                    .resizable()
                    .frame(width: 16, height: 16)
                
                Text("누적 구매 \(viewModel.output.activityDetails.totalOrderCount)회")
                    .font(.Body.body3.weight(.medium))
                    .foregroundStyle(.gray45)
            }
            
            HStack(spacing: 2) {
                Image(.icnKeepCount)
                    .resizable()
                    .frame(width: 16, height: 16)
                
                Text("KEEP \(viewModel.output.activityDetails.summary.keepCount)회")
                    .font(.Body.body3.weight(.medium))
                    .foregroundStyle(.gray45)
            }
        }
    }
    
    func restrictionView() -> some View {
        HStack {
            restrictionComponents(.age, value: "\(viewModel.output.activityDetails.restrictions.minAge)세")
            Spacer()
            restrictionComponents(.height, value: "\(viewModel.output.activityDetails.restrictions.minHeight)cm")
            Spacer()
            restrictionComponents(.people, value: "\(viewModel.output.activityDetails.restrictions.maxParticipants)명")
        }
        .padding()
        .asRoundedBackground(cornerRadius: 16, strokeColor: .gray30)
    }
    
    func restrictionComponents(_ restriction: Restrictions, value: String) -> some View {
        HStack(spacing: 8) {
            Image(restriction.icon)
                .resizable()
                .frame(width: 32, height: 32)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(restriction.title)
                    .font(.Caption.caption2)
                    .foregroundStyle(.gray45)
                
                Text(value)
                    .font(.Body.body3.bold())
                    .foregroundStyle(.gray75)
            }
        }
    }
    
    func priceView() -> some View {
        VStack {
            LargePriceView(
                originPrice: viewModel.output.activityDetails.summary.originalPrice,
                finalPrice: viewModel.output.activityDetails.summary.finalPrice
            )
        }
    }
    
    enum Restrictions {
        case age
        case height
        case people
        
        var icon: ImageResource {
            switch self {
            case .age:
                return .restrictionAge
            case .height:
                return .restrictionHeight
            case .people:
                return .restrictionPeople
            }
        }
        
        var title: String {
            switch self {
            case .age:
                return "연령제한"
            case .height:
                return "신장제한"
            case .people:
                return "최대참가인원"
            }
        }
    }
}

// MARK: - Curriculum
private extension ActivityDetailView {
    func curriculumView() -> some View {
        VStack {
            SectionHeader(title: "액티비티 커리큘럼", color: .gray45)
            curriculumInfoView()
        }
    }
    
    func curriculumInfoView() -> some View {
        let schedules = viewModel.output.activityDetails.schedule
        
        return VStack(alignment: .leading, spacing: 12) {
            LazyVStack(alignment: .leading) {
                ForEach(schedules.indices, id: \.self) { idx in
                    let schedule = schedules[idx]
                    timelineRowView(
                        schedule: schedule,
                        isLast: idx == schedules.count - 1
                    )
                }
            }
            .padding(.top,36)
            .padding(.horizontal)
            
            // TODO: LocationView
        }
        .asRoundedBackground(cornerRadius: 16, strokeColor: .gray30)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func timelineRowView(schedule: ScheduleEntity, isLast: Bool) -> some View {
        if let duration = schedule.duration,
           let description = schedule.description {
            HStack(alignment: .top, spacing: 20) {
                VStack(spacing: 4) {
                    Circle()
                        .fill(Color.colLight)
                        .frame(width: 8, height: 8)
                    
                    if !isLast {
                        Rectangle()
                            .fill(Color.colLight)
                            .frame(width: 2)
                            .frame(minHeight: 28)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(duration)
                        .font(.Caption.caption2.weight(.medium))
                        .foregroundColor(.gray45)
                    
                    Text(description)
                        .font(.Body.body3.bold())
                        .foregroundColor(.gray75)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .offset(y: -20)
                
                Spacer()
            }
            .padding(.bottom, isLast ? 0 : 4)
        } else {
            EmptyResultView()
        }
    }
}

// MARK: - Reservation
private extension ActivityDetailView {
    func reservationView() -> some View {
        VStack(alignment: .leading) {
            SectionHeader(title: "액티비티 예약", color: .gray45)
            dateSelectionView()
            timeSlotView()
        }
    }
    
    func dateSelectionView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(viewModel.output.reservations, id: \.itemName) { reservation in
                    let isAvailable = viewModel.isDateAvailable(reservation.itemName)
                    let isSelected = viewModel.output.selectedDate == reservation.itemName
                    
                    Text(reservation.itemName)
                        .asButton {
                            if isAvailable {
                                viewModel.action(.selectDate(itemName: reservation.itemName))
                            }
                        }
                        .font(isSelected ? .Body.body3.weight(.bold) : .Body.body3.weight(.medium))
                        .frame(width: 78, height: 32)
                        .foregroundStyle(
                            isSelected ? .colDeep :
                                isAvailable ? .gray75 : .gray45
                        )
                        .background(
                            isSelected ? .colDeep.opacity(0.5) :
                                isAvailable ? Color.white : Color.gray15
                        )
                        .overlay(
                            Capsule()
                                .stroke(
                                    isSelected ? Color.colDeep : Color.gray30,
                                    lineWidth: 2
                                )
                        )
                        .clipShape(Capsule())
                        .disabled(!isAvailable)
                }
            }
            .padding(.horizontal)
        }
    }
    
    func timeSlotView() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            let timeSlots = viewModel.getTimeSlotsForSelectedDate()
            let morningSlots = timeSlots.filter { !viewModel.isAfternoon($0.time) }
            let afternoonSlots = timeSlots.filter { viewModel.isAfternoon($0.time) }
            
            if !morningSlots.isEmpty {
                timeSlotSection(title: "오전", slots: morningSlots)
            }
            
            if !afternoonSlots.isEmpty {
                timeSlotSection(title: "오후", slots: afternoonSlots)
            }
        }
        .padding()
        .asRoundedBackground(cornerRadius: 16, strokeColor: .gray30)
        .padding()
    }
    
    func timeSlotSection(title: String, slots: [TimeSlotEntity]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.Body.body3.weight(.medium))
                .foregroundColor(.gray45)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4), spacing: 8) {
                ForEach(Array(slots.enumerated()), id: \.offset) { index, slot in
                    let isSelected = viewModel.output.selectedTimeSlot?.time == slot.time
                    let isAvailable = !slot.isReserved
                    
                    Text(viewModel.formatTime(slot.time))
                        .asButton {
                            if isAvailable {
                                viewModel.action(.selectTimeSlot(timeSlot: slot))
                            }
                        }
                        .font(isSelected ? .Body.body3.weight(.bold) : .Body.body3.weight(.medium))
                        .frame(width: 68, height: 32)
                        .foregroundStyle(
                            isSelected ? .colDeep :
                                isAvailable ? .gray75 : .gray45
                        )
                        .background(
                            isSelected ? .colDeep.opacity(0.5) :
                                isAvailable ? Color.white : Color.gray15
                        )
                        .overlay(
                            Capsule()
                                .stroke(
                                    isSelected ? Color.colDeep : Color.gray30,
                                    lineWidth: 2
                                )
                        )
                        .clipShape(Capsule())
                        .disabled(!isAvailable)
                }
            }
        }
    }
}

// MARK: - Creator
private extension ActivityDetailView {
    func creatorView() -> some View {
        VStack {
            SectionHeader(title: "호스트 정보", color: .gray45)
            creatorInfoView()
        }
    }
    
    func creatorInfoView() -> some View {
        HStack(spacing: 12) {
            KFRemoteImageView(
                path: viewModel.output.activityDetails.creator.profileImageURL ?? "",
                aspectRatio: 1,
                cachePolicy: .memoryOnly,
                height: 38
            )
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.output.activityDetails.creator.nick)
                    .font(.Body.body3.bold())
                    .foregroundStyle(.gray75)
                
                Text(viewModel.output.activityDetails.creator.introduction ?? "")
                    .font(.Caption.caption1.weight(.regular))
                    .foregroundStyle(.gray45)
                    .lineLimit(1)
            }
            Spacer()
            
            chatButton()
        }
        .padding()
        .asRoundedBackground(cornerRadius: 16, strokeColor: .gray30)
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    func chatButton() -> some View {
        let opponentId = viewModel.output.activityDetails.creator.id
        
        return Text("채팅하기")
            .font(.Caption.caption1.weight(.semibold))
            .foregroundStyle(.white)
            .padding()
            .frame(width: 78, height: 32)
            .background(.colBlack)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .asButton {
                pathModel.push(.chatRoom(id: opponentId))
            }
    }
}

// MARK: - Payment
private extension ActivityDetailView {
    func paymentView() -> some View {
        let price = viewModel.output.activityDetails.summary.finalPrice
        
        return HStack {
            Text("\(price)원")
                .font(.Title.title1.bold())
                .foregroundStyle(.gray90)
            
            Spacer()
            
            ActionButton(text: "결제하기") {
                // TODO: Order API를 타고 order_code받아서 paymentSheet로 넘기기
                pathModel.presentFullScreenCover(.payment(price: price))
            }
            .frame(width: 140)
        }
        .padding()
        .frame(height: 100, alignment: .top)
        .frame(maxWidth: .infinity)
        .background(
            .ultraThinMaterial,
            in: .rect
        )
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: -4)
    }
    
    // 결제 응답 처리
    // TODO: response를 Notification으로 onAppear로 받을때 실행
    private func handlePaymentResponse(_ response: IamportResponse?) {
        guard let response = response else {
            print("결제 응답이 없습니다.")
            return
        }
        
        print("결제 결과: \(response)")
        
        // 결제 성공/실패에 따른 처리
        if response.success == true {
            // 결제 성공 시 서버에 검증 요청 등
            print("결제 성공: \(response.imp_uid ?? "")")
        } else {
            // 결제 실패 시 처리
            print("결제 실패: \(response.error_msg ?? "")")
        }
    }
}

// MARK: - Toolbar
private extension ActivityDetailView {
    func keepButton() -> some View {
        let isKeep = viewModel.output.isKeep
        return Image(isKeep ? .icnLikeFill : .icnLikeEmpty)
            .asButton {
                viewModel.action(.keepToggle(keepStatus: !isKeep))
            }
    }
}
