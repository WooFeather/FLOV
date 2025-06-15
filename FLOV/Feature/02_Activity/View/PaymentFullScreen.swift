//
//  PaymentFullScreen.swift
//  FLOV
//
//  Created by 조우현 on 6/13/25.
//

import SwiftUI
import UIKit
import WebKit
import iamport_ios

struct PaymentFullScreen: UIViewControllerRepresentable {
    let price: Int
    
    func makeUIViewController(context: Context) -> UIViewController {
        let paymentVC = PaymentSheetViewController()
        paymentVC.price = price
        
        let navController = UINavigationController(rootViewController: paymentVC)
        return navController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

// MARK: - Payment Sheet ViewController
class PaymentSheetViewController: UIViewController {
    var price: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 뷰가 완전히 나타난 후 결제 시작
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.requestIamportPayment()
        }
    }
    
    private func setupNavigationBar() {
        title = "결제하기"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTapped)
        )
    }
    
    @objc private func cancelTapped() {
        self.dismiss(animated: true)
    }
    
    // 아임포트 SDK 결제 요청
    func requestIamportPayment() {
        let userCode = "imp14511373" // SLP userCode
        let payment = createPaymentData()
        
        // UIKit 방식으로 결제 요청 (이미 검증된 방식)
        Iamport.shared.payment(
            viewController: self,
            userCode: userCode,
            payment: payment
        ) { [weak self] response in
            DispatchQueue.main.async {
                // TODO: NotificationCenter로 response 전달
                self?.dismiss(animated: true)
            }
        }
    }
    
    // 아임포트 결제 데이터 생성
    func createPaymentData() -> IamportPayment {
        return IamportPayment(
            pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"),
            merchant_uid: "HBNY413003", // /v1/orders 라우터응답값 order_code
            amount: "\(price)" // 실제 결제 금액 사용
        ).then {
            $0.pay_method = PayMethod.card.rawValue
            $0.name = "액티비티 결제" // 결제 유저가 보기에 적절한 값으로 수정
            $0.buyer_name = "홍길동"
            $0.app_scheme = "kakao\(Config.kakaoNativeAppKey)" // 결제 후 돌아올 앱스킴
        }
    }
}
