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
    let name: String
    let price: Int
    let orderCode: String
    
    func makeUIViewController(context: Context) -> UIViewController {
        let paymentVC = PaymentSheetViewController()
        paymentVC.price = price
        paymentVC.orderCode = orderCode
        paymentVC.name = name
        
        let navController = UINavigationController(rootViewController: paymentVC)
        return navController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

// MARK: - PaymentSheetViewController
final class PaymentSheetViewController: UIViewController {
    var name: String = ""
    var price: Int = 0
    var orderCode: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configView()
        print("OrderCode:", orderCode)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.requestIamportPayment()
        }
    }
}

// MARK: - IamportConfiguration
extension PaymentSheetViewController {
    // 아임포트 SDK 결제 요청
    func requestIamportPayment() {
        let userCode = "imp14511373" // SLP userCode
        let payment = createPaymentData()
        
        Iamport.shared.payment(
            viewController: self,
            userCode: userCode,
            payment: payment
        ) { [weak self] response in
            NotificationCenter.default.post(
                name: .paymentCompleted,
                object: nil,
                userInfo: ["response": response ?? [:]]
            )
            
            DispatchQueue.main.async {
                self?.dismiss(animated: true)
            }
        }
    }
    
    // 아임포트 결제 데이터 생성
    func createPaymentData() -> IamportPayment {
        return IamportPayment(
            pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"),
            merchant_uid: orderCode,
            amount: "\(price)"
        ).then {
            $0.pay_method = PayMethod.card.rawValue
            $0.name = name
            $0.buyer_name = "홍길동"
            $0.app_scheme = "kakao\(Config.kakaoNativeAppKey)" // 결제 후 돌아올 앱스킴
        }
    }
}

// MARK: - ViewConfiguration
extension PaymentSheetViewController {
    private func configView() {
        view.backgroundColor = .systemBackground
        configNavigationBar()
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func configNavigationBar() {
        title = "액티비티 결제"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTapped)
        )
    }
    
    @objc private func cancelTapped() {
        self.dismiss(animated: true)
    }
}
