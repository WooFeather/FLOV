//
//  LocationService.swift
//  FLOV
//
//  Created by 조우현 on 6/22/25.
//

import Foundation
import CoreLocation
import Combine

protocol LocationServiceType {
    var currentLocation: AnyPublisher<CLLocation?, Never> { get }
    var authorizationStatus: AnyPublisher<CLAuthorizationStatus, Never> { get }
    var infoPublisher: AnyPublisher<String, Never> { get }
    var lastKnownLocation: CLLocation? { get }
    
    func requestLocationPermission()
    func getCurrentLocation()
}

final class LocationService: NSObject, LocationServiceType {
    private let locationManager = CLLocationManager()
    private let currentLocationSubject = CurrentValueSubject<CLLocation?, Never>(nil)
    private let authorizationStatusSubject = CurrentValueSubject<CLAuthorizationStatus, Never>(.notDetermined)
    private let infoSubject = PassthroughSubject<String, Never>()
    
    // 기본 위치 (서울시청)
    private let defaultLocation = CLLocation(
        latitude: 37.565679812037345,
        longitude: 126.97796779294629
    )
    
    var currentLocation: AnyPublisher<CLLocation?, Never> {
        currentLocationSubject.eraseToAnyPublisher()
    }
    var authorizationStatus: AnyPublisher<CLAuthorizationStatus, Never> {
        authorizationStatusSubject.eraseToAnyPublisher()
    }
    var infoPublisher: AnyPublisher<String, Never> {
        infoSubject.eraseToAnyPublisher()
    }
    var lastKnownLocation: CLLocation? {
        currentLocationSubject.value
    }
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        authorizationStatusSubject.send(locationManager.authorizationStatus)
    }
    
    func requestLocationPermission() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .authorizedWhenInUse, .authorizedAlways:
            getCurrentLocation()
            
        case .denied, .restricted:
            infoSubject.send("위치 권한이 비활성화되어 있습니다.\n기본 위치로 게시물을 불러옵니다.")
            currentLocationSubject.send(defaultLocation)
            
        @unknown default:
            break
        }
    }
    
    func getCurrentLocation() {
        let status = locationManager.authorizationStatus
        guard status == .authorizedWhenInUse || status == .authorizedAlways else {
            // 권한 없으면 다시 요청 로직으로 분기
            requestLocationPermission()
            return
        }
        locationManager.requestLocation()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        currentLocationSubject.send(loc)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // 위치 업데이트 실패 시 안내 + 기본 위치
        print("Location error: \(error.localizedDescription)")
        infoSubject.send("위치를 가져오지 못해 기본 위치로 불러옵니다.")
        currentLocationSubject.send(defaultLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatusSubject.send(status)
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            getCurrentLocation()
        case .denied, .restricted:
            // 권한 거부 시 동일하게 폴백 처리
            infoSubject.send("위치 권한이 비활성화되어 있습니다.\n기본 위치로 게시물을 불러옵니다.")
            currentLocationSubject.send(defaultLocation)
        default:
            break
        }
    }
}
