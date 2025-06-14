//
//  PaymentView.swift
//  FLOV
//
//  Created by 조우현 on 6/13/25.
//

import SwiftUI
import UIKit
import WebKit
import iamport_ios


struct PaymentView: UIViewControllerRepresentable {
//    @EnvironmentObject var viewModel: ViewModel

    func makeUIViewController(context: Context) -> UIViewController {
        let view = PaymentViewController()
//        view.viewModel = viewModel
        return view
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

class PaymentViewController: UIViewController, WKNavigationDelegate {
//    var viewModel: ViewModel? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        print("PaymentView viewDidLoad")

        view.backgroundColor = UIColor.white
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("PaymentView viewWillAppear")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("PaymentView viewDidAppear")
        requestIamportPayment()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("PaymentView viewWillDisappear")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("PaymentView viewDidDisappear")
    }


    // 아임포트 SDK 결제 요청
    func requestIamportPayment() {
        let userCode = "iamport" // iamport 에서 부여받은 가맹점 식별코드
        let payment = createPaymentData()
        
        Iamport.shared.payment(viewController: self,
                userCode: userCode, payment: payment) { response in
            print("결과 : \(String(describing: response))")
        }
      }
    
    // 아임포트 결제 데이터 생성
      func createPaymentData() -> IamportPayment {
        return IamportPayment(
                pg: PG.html5_inicis.makePgRawName(pgId: ""),
                merchant_uid: "swiftui_ios_\(Int(Date().timeIntervalSince1970))",
                amount: "1000").then {
          $0.pay_method = "card"
          $0.name = "SwiftUI 에서 주문입니다"
          $0.buyer_name = "SwiftUI"
          $0.app_scheme = "iamporttest" // 결제 후 돌아올 앱스킴
        }
      }
//    func requestPayment() {
//        guard let viewModel = viewModel else {
//            print("viewModel 이 존재하지 않습니다.")
//            return
//        }
//
//        let userCode = viewModel.order.userCode // iamport 에서 부여받은 가맹점 식별코드
//        if let payment = viewModel.createPaymentData() {
//            dump(payment)
//
////          #case1 use for UIViewController
////          WebViewController 용 닫기버튼 생성(PG "uplus(토스페이먼츠 구모듈)"는 자체취소 버튼이 없는 것으로 보임)
//            Iamport.shared.useNavigationButton(enable: true)
//
//            Iamport.shared.payment(viewController: self,
//                userCode: userCode.value, payment: payment) { response in
//                viewModel.iamportCallback(response)
//            }
//
////          #case2 use for navigationController
////          guard let navController = navigationController else {
////              print("navigationController 를 찾을 수 없습니다")
////              return
////          }
////
////          Iamport.shared.payment(navController: navController,
////              userCode: userCode.value, iamportRequest: request) { iamportResponse in
////              viewModel.iamportCallback(iamportResponse)
////          }
//        }
//    }

}

#Preview {
    PaymentView()
}
